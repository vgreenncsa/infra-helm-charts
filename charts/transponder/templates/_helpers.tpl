{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "ketch.transponder.name" -}}
{{- .Values.nameOverride | default .Chart.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "ketch.transponder.fullname" -}}
{{- $name := "" -}}
{{- if .Values.fullnameOverride -}}
{{- $name = .Values.fullnameOverride -}}
{{- else -}}
{{- $rawName := (.Values.nameOverride | default .Chart.Name) -}}
{{- if contains $rawName .Release.Name -}}
{{- $name = .Release.Name -}}
{{- else -}}
{{- $name = printf "%s-%s" .Release.Name $rawName -}}
{{- end -}}
{{- end -}}
{{- $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "ketch.transponder.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Application version
*/}}
{{- define "ketch.transponder.version" -}}
{{- .Values.global.image.tag | default .Chart.AppVersion -}}
{{- end -}}

{{/*
Image pull policy
*/}}
{{- define "ketch.transponder.imagePullPolicy" -}}
{{- .Values.global.image.pullPolicy -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "ketch.transponder.labels" -}}
{{ include "ketch.transponder.matchLabels" . }}
helm.sh/chart: {{ include "ketch.transponder.chart" . }}
app.kubernetes.io/version: {{ include "ketch.transponder.version" . | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- if .Values.commonLabels }}
{{ toYaml .Values.commonLabels }}
{{- end }}
{{- end -}}

{{/*
Common selector/matching labels
*/}}
{{- define "ketch.transponder.matchLabels" -}}
app: {{ include "ketch.transponder.name" . }}
app.kubernetes.io/name: {{ include "ketch.transponder.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Common annotations
*/}}
{{- define "ketch.transponder.annotations" -}}
{{- if .Values.commonAnnotations }}
{{ toYaml .Values.commonAnnotations }}
{{- end }}
{{- end -}}

{{/*
Common deployment patterns
*/}}
{{- define "ketch.transponder.deployment.deploymentStrategy" -}}
{{- with . -}}
type: {{ .type | default "RollingUpdate" }}
rollingUpdate:
  maxSurge: {{ .rollingUpdate.maxSurge | default "25%" }}
  maxUnavailable: {{ .rollingUpdate.maxUnavailable | default "25%" }}
{{- else -}}
type: RollingUpdate
rollingUpdate:
  maxSurge: 25%
  maxUnavailable: 25%
{{- end -}}
{{- end -}}

{{- define "ketch.transponder.deployment.env.secretProvider" -}}
{{- $aws := .context.Values.config.aws -}}
{{- $vault := .context.Values.config.vault -}}
{{- $azure := .context.Values.config.azure -}}
{{- $googleSecretsManager := .context.Values.config.googleSecretsManager -}}
{{- $component := .component | upper -}}
{{- $provider := (.context.Values.secret.provider | default (ternary "vault" "awsSecretsManager" .context.Values.config.vault.enabled)) -}}
- name: {{ $component }}_SECRET_PROVIDER
  value: "{{ $provider }}"
{{- if eq $provider "awsSecretsManager" }}
# Start of AWS Secrets Manager config
{{- if $aws.keyId }}
- name: AWS_ACCESS_KEY_ID
  valueFrom:
    secretKeyRef:
      name: {{ include "ketch.transponder.fullname" .context }}-confvars
      key: aws_access_key_id
- name: AWS_SECRET_ACCESS_KEY
  valueFrom:
    secretKeyRef:
      name: {{ include "ketch.transponder.fullname" .context }}-confvars
      key: aws_secret_access_key
{{- end }}
- name: {{ $component }}_AWS_SECRETS_PREFIX
  value: "{{ $aws.secretsManager.prefix }}"
# End of AWS Secrets Manager config
{{- end }}
{{- if eq $provider "vault" }}
# Start of Vault config
- name: {{ $component }}_VAULT_ADDRESS
  value: "{{ $vault.address }}"
- name: {{ $component }}_VAULT_TOKEN
  valueFrom:
    secretKeyRef:
      name: "{{ ($vault.secret).name | default (printf "%s-confvars" (include "ketch.transponder.fullname" .context)) }}"
      key: "{{ ($vault.secret).key | default "vault_token" }}"
- name: {{ $component }}_VAULT_PREFIX
  value: "{{ $vault.prefix }}"
- name: {{ $component }}_VAULT_TLS_ENABLED
  value: "true"
{{- if $vault.tls }}
- name: {{ $component }}_VAULT_TLS_INSECURE
  value: "{{ $vault.tls.insecure | default "false" }}"
- name: {{ $component }}_VAULT_TLS_OVERRIDE
  value: "{{ $vault.tls.override }}"
{{- if and (($vault.tls).cert).content (($vault.tls).key).content }}
- name: {{ $component }}_VAULT_TLS_CERT_FILE
  value: "/tls/vault/{{ include "ketch.transponder.tls.cert.file" $vault }}"
- name: {{ $component }}_VAULT_TLS_KEY_FILE
  value: "/tls/vault/{{ include "ketch.transponder.tls.key.file" $vault }}"
{{- if (($vault.tls).rootca).content }}
- name: {{ $component }}_VAULT_TLS_ROOTCA_FILE
  value: "/tls/vault/{{ include "ketch.transponder.tls.rootca.file" $vault }}"
{{- else if .context.Values.config.tls.rootca.content }}
- name: {{ $component }}_VAULT_TLS_ROOTCA_FILE
  value: "/tls/{{ include "ketch.transponder.tls.rootca.file" .context.Values.config }}"
{{- end }}
{{- end }}
{{- end }}
# End of Vault config
{{- end }}
{{- if eq $provider "azureKeyVault" }}
# Start of Azure Key Vault config
- name: {{ $component }}_AZURE_SECRETS_VAULT_URI
  value: "{{ $azure.vaultURI }}"
- name: {{ $component }}_AZURE_SECRETS_PREFIX
  value: "{{ $azure.prefix }}"
- name: {{ $component }}_AZURE_SECRETS_TENANT_ID
  value: "{{ $azure.tenantID }}"
- name: {{ $component }}_AZURE_SECRETS_CLIENT_ID
  value: "{{ $azure.client.id }}"
- name: {{ $component }}_AZURE_SECRETS_CLIENT_SECRET
  valueFrom:
    secretKeyRef:
      name: {{ include "ketch.transponder.fullname" .context }}-confvars
      key: azure_client_secret
# End of Azure Key Vault config
{{- end }}
{{- if eq $provider "googleSecretsManager" }}
# Start of Google Secrets Manager config
- name: {{ $component }}_GOOGLE_SECRETS_PROJECT_ID
  value: "{{ $googleSecretsManager.projectID }}"
- name: {{ $component }}_GOOGLE_SECRETS_PREFIX
  value: "{{ $googleSecretsManager.prefix }}"
{{- if and $googleSecretsManager.secret.name $googleSecretsManager.secret.key }}
- name: {{ $component }}_GOOGLE_SECRETS_KEY
  valueFrom:
    secretKeyRef:
      name: {{ $googleSecretsManager.secret.name }}
      key: {{ $googleSecretsManager.secret.key }}
{{- else }}
- name: {{ $component }}_GOOGLE_SECRETS_KEY
  valueFrom:
    secretKeyRef:
      name: {{ include "ketch.transponder.fullname" .context }}-confvars
      key: google_secrets_key
{{- end }}
# End of Google Secrets Manager config
{{- end }}
{{- end -}}

{{- define "ketch.transponder.deployment.probe" -}}
{{- $port := (get .context.Values.config .component).listen -}}
{{- $tls_host := .context.Values.config.tls.override -}}
{{- $probe := (get (get .context.Values.config .component) .probe.name) -}}
httpGet:
  path: /healthz
  port: {{ $port | default "5000" }}
  scheme: HTTPS
  httpHeaders:
    - name: Host
      value: {{ $tls_host | default "transponder" }}
{{- if $probe }}
{{ toYaml $probe }}
{{- else }}
{{ toYaml .probe.default }}
{{- end }}
{{- end -}}

{{- define "ketch.transponder.deployment.readinessProbe" -}}
{{- $default := (dict "initialDelaySeconds" 3 "periodSeconds" 10 "timeoutSeconds" 1 "successThreshold" 1 "failureThreshold" 3) -}}
{{- $probe := (dict "name" "readinessProbe" "default" $default) -}}
{{ include "ketch.transponder.deployment.probe" (mustMerge (dict "probe" $probe) .) }}
{{- end -}}

{{- define "ketch.transponder.deployment.livenessProbe" -}}
{{- $default := (dict "initialDelaySeconds" 15 "periodSeconds" 20 "timeoutSeconds" 1 "successThreshold" 1 "failureThreshold" 3) -}}
{{- $probe := (dict "name" "livenessProbe" "default" $default) -}}
{{ include "ketch.transponder.deployment.probe" (mustMerge (dict "probe" $probe) .) }}
{{- end -}}

{{- define "ketch.transponder.deployment.volume.server.tls" -}}
{{- if .Values.config.tls.cert.content }}
- secret:
    name: {{ include "ketch.transponder.fullname" . }}-confvars
    items:
      - key: tls.cert
        path: {{ include "ketch.transponder.tls.cert.file" .Values.config }}
      - key: tls.key
        path: {{ include "ketch.transponder.tls.key.file" .Values.config }}
{{- if .Values.config.tls.rootca.content }}
      - key: ca.crt
        path: {{ include "ketch.transponder.tls.rootca.file" .Values.config }}
{{- end }}
{{- end }}
{{- end -}}

{{- define "ketch.transponder.deployment.volume.vault.tls" -}}
{{- $provider := (.Values.secret.provider | default (ternary "vault" "awsSecretsManager" .Values.config.vault.enabled)) -}}
{{- if eq $provider "vault" }}
{{- if and ((.Values.config.vault.tls).cert).content ((.Values.config.vault.tls).key).content }}
- secret:
    name: {{ include "ketch.transponder.fullname" . }}-confvars
    items:
      - key: vault_tls.cert
        path: "vault/{{ include "ketch.transponder.tls.cert.file" .Values.config.vault }}"
      - key: vault_tls.key
        path: "vault/{{ include "ketch.transponder.tls.key.file" .Values.config.vault }}"
{{- if ((.Values.config.vault.tls).rootca).content }}
      - key: vault_ca.crt
        path: "vault/{{ include "ketch.transponder.tls.rootca.file" .Values.config.vault }}"
{{- end }}
{{- end }}
{{- end }}
{{- end -}}

{{- define "ketch.transponder.deployment.securityContext" -}}
{{- with . }}
{{- toYaml . }}
{{- else }}
capabilities:
  drop:
    - ALL
readOnlyRootFilesystem: true
runAsNonRoot: true
runAsUser: 1000
{{- end }}
{{- end -}}

{{- define "ketch.transponder.deployment.podSecurityContext" -}}
{{- with . }}
{{- toYaml . }}
{{- else }}
fsGroup: 2000
{{- end }}
{{- end -}}

{{/*
Image pull secret formatter
*/}}
{{- define "ketch.transponder.imagePullSecret" -}}
{{- $registry := .Values.imageCredentials.registry -}}
{{- $username := (.Values.imageCredentials.username | default (printf "transponder-%s" $.Values.config.org)) -}}
{{- $password := (required "A valid .Values.imageCredentials.password entry required!" .Values.imageCredentials.password) -}}
{{- printf "{\"auths\": {\"%s\": {\"auth\": \"%s\"}}}" $registry (printf "%s:%s" $username $password | b64enc) | b64enc -}}
{{- end -}}

{{/*
File names for TLS cert
*/}}
{{- define "ketch.transponder.tls.cert.file" -}}
{{- .tls.cert.file | default "tls.crt" -}}
{{- end -}}

{{- define "ketch.transponder.tls.key.file" -}}
{{- .tls.key.file | default "tls.key" -}}
{{- end -}}

{{- define "ketch.transponder.tls.rootca.file" -}}
{{- .tls.rootca.file | default "ca.crt" -}}
{{- end -}}

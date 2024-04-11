{{- define "ketch.transponder.agent.fullname" -}}
{{- printf "%s-agent" (include "ketch.transponder.fullname" .) }}
{{- end -}}

{{- define "ketch.transponder.agent.labels" -}}
{{ include "ketch.transponder.labels" . }}
app.kubernetes.io/component: agent
{{- end -}}

{{- define "ketch.transponder.agent.matchLabels" -}}
{{ include "ketch.transponder.matchLabels" . }}
app.kubernetes.io/component: agent
{{- end -}}

{{- define "ketch.transponder.agent.serviceAccountName" -}}
{{- .Values.config.agent.serviceAccount.name | default .Values.serviceAccount.name | default (printf "%s-agent" (include "ketch.transponder.fullname" .)) -}}
{{- end -}}

{{- define "ketch.transponder.agent.image" -}}
{{ (.Values.config.agent.image).repository | default "ketch.jfrog.io/ketch-docker/transponder/agent" }}
{{- end -}}

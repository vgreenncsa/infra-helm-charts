{{- define "ketch.transponder.sonar.fullname" -}}
{{- printf "%s-sonar" (include "ketch.transponder.fullname" .) -}}
{{- end -}}

{{- define "ketch.transponder.sonar.labels" -}}
{{ include "ketch.transponder.labels" . }}
app.kubernetes.io/component: sonar
{{- end -}}

{{- define "ketch.transponder.sonar.matchLabels" -}}
{{ include "ketch.transponder.matchLabels" . }}
app.kubernetes.io/component: sonar
{{- end -}}

{{- define "ketch.transponder.sonar.serviceAccountName" -}}
{{- .Values.config.sonar.serviceAccount.name | default .Values.serviceAccount.name | default (printf "%s-sonar" (include "ketch.transponder.fullname" .)) -}}
{{- end -}}

{{- define "ketch.transponder.sonar.image" -}}
{{ (.Values.config.sonar.image).repository | default "ketch.jfrog.io/ketch-docker/transponder/sonar" }}
{{- end -}}

{{- define "ketch.transponder.transponder.fullname" -}}
{{- printf "%s-transponder" (include "ketch.transponder.fullname" .) }}
{{- end -}}

{{- define "ketch.transponder.transponder.labels" -}}
{{ include "ketch.transponder.labels" . }}
app.kubernetes.io/component: transponder
{{- end -}}

{{- define "ketch.transponder.transponder.matchLabels" -}}
{{ include "ketch.transponder.matchLabels" . }}
app.kubernetes.io/component: transponder
{{- end -}}

{{- define "ketch.transponder.transponder.annotations" -}}
{{ include "ketch.transponder.annotations" . }}
{{- end -}}

{{- define "ketch.transponder.transponder.serviceAccountName" -}}
{{- .Values.config.transponder.serviceAccount.name | default .Values.serviceAccount.name | default (printf "%s-transponder" (include "ketch.transponder.fullname" .)) -}}
{{- end -}}

{{- define "ketch.transponder.transponder.image" -}}
{{ (.Values.config.transponder.image).repository | default "ketch.jfrog.io/ketch-docker/transponder/transponder" }}
{{- end -}}

{{/* vim: set filetype=mustache: */}}
{{/*
Kubernetes standard labels
*/}}
{{- define "common.labels.standard" -}}
app.kubernetes.io/name: {{ .Release.Name }}
helm.sh/chart: {{ include "common.names.chart" . }}
app.kubernetes.io/instance: {{ include "common.names.fullname" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
prometheus.deckhouse.io/custom-target: {{ .Release.Name }}
{{- end -}}

{{/*
Labels to use on deploy.spec.selector.matchLabels and svc.spec.selector
*/}}
{{- define "common.labels.matchLabels" -}}
app.kubernetes.io/name: {{ .Release.Name }}
app.kubernetes.io/instance: {{ include "common.names.fullname" . }}
{{- end -}}

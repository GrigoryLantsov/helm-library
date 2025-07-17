{{/* vim: set filetype=mustache: */}}

{{/*
Kubernetes standard labels
*/}}
{{- define "common.labels.standard" }}
app.kubernetes.io/name: {{ .Release.Name }}
helm.sh/chart: {{ include "common.names.chart" . }}
app.kubernetes.io/instance: {{ include "common.names.fullname" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Labels to use on deploy.spec.selector.matchLabels and svc.spec.selector
*/}}
{{- define "common.labels.matchLabels" }}
app.kubernetes.io/name: {{ .Release.Name }}
app.kubernetes.io/instance: {{ include "common.names.fullname" . }}
{{- end }}

{{/*
metadata.labels
*/}}
{{- define "common.labels.metadata" }}
{{- include "common.labels.standard" . | indent 4 }}
{{- if .Values.commonLabels }}
  {{- include "common.tplvalues.render" (dict "value" .Values.commonLabels "context" $) | indent 4 }}
{{- end }}
{{- end }}

{{/*
template.metadata.labels
*/}}
{{- define "common.labels.template.metadata" }}
{{- include "common.labels.standard" . | indent 8 }}
{{- if .Values.podLabels }}
  {{- include "common.tplvalues.render" (dict "value" .Values.podLabels "context" $) | indent 8 }}
{{- end }}
{{- end }}

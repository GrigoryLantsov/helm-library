{{/* vim: set filetype=mustache: */}}

{{/*
Return a spec_log for kibana
{{- include "common.annotations.logKibana" . }}
*/}}
{{- define "common.annotations.logKibana" }}
{{- if .Values.annotations.logKibana.enabled }}
eisgs.spec_log.enable: "true"
{{- end }}
{{- end }}

{{/*
autoreload pod if smth in volumes changed
{{- include "common.annotations.autoreloader" . }}
*/}}
{{- define "common.annotations.autoreloader" }}
{{- if .Values.global.autoreloader }}
pod-reloader.deckhouse.io/auto: "true"
{{- end }}
{{- end }}

{{/*
metadata.annotations
*/}}
{{- define "common.annotations.metadata" }}
{{- if .Values.commonAnnotations }}
  {{- include "common.tplvalues.render" ( dict "value" .Values.commonAnnotations "context" $ ) | indent 4 }}
{{- else if .Values.application.config }}
  checksum/cm-config: {{ print "/opt/node-app/config.json" . | sha256sum | indent 4 }}
{{- end }}
{{- end }}

{{/*
template.metadata.annotations
*/}}
{{- define "common.annotations.template.metadata" }}
{{- include "common.annotations.autoreloader" . | indent 8 }}
{{- if .Values.secrets.enabled }}
  {{- include "common.secrets.annotations" . | indent 8 }}
{{- end }}
{{- include "common.annotations.logKibana" . | indent 8 }}
{{- end }}

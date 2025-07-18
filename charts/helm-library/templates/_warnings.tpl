{{/* vim: set filetype=mustache: */}}

{{/*
Warning about using rolling tag.
Usage:
{{- include "common.warnings.rollingTag" .Values.path.to.the.imageRoot }}
*/}}
{{- define "common.warnings.rollingTag" }}
{{- if .tag | regexFind "-r\\d+$|sha256:" }}
WARNING: Rolling tag detected ({{ .repository }}:{{ .tag }}), please note that it is strongly recommended to avoid using rolling tags in a production environment.
{{- end }}
{{- end }}

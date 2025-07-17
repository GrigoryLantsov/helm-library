# vi:syntax=yaml
# vi:filetype=yaml

{{/*
Get envs from values
*/}}
{{- define "common.env.envs" }}
{{- if .Values.global.env }}
{{- range $key, $map := .Values.application.env }}
  {{- if pluck $.Values.global.env $map }}
  - name: {{ $key }}
    value: {{ pluck $.Values.global.env $map | first | quote }}
  {{- else if $map._default }}
  - name: {{ $key }}
    value: {{ $map._default | quote }}
  {{- end }}
{{- end }}
{{- else }}
{{- range $key, $value := .Values.application.env }}
- name: {{ $key }}
  value: {{ $value }}
{{- end }}
{{- end }}
{{- end }}

{{- define "common.env.envSecretVars" -}}
{{- $fullName := include "common.names.fullname" . -}}
{{- range $key, $map := .Values.application.secret }}
  - secretRef:
      name: {{ $fullName }}-{{ $key | replace "_" "-" }}
{{- end }}
{{- end }}

# vi:syntax=yaml
# vi:filetype=yaml

{{/*
Get envs from values
*/}}
{{- define "common.env.envs" -}}
{{- if .Values.global.env }}
{{- range $key, $map := .Values.application.env }}
  {{- if $map._default }}
  - name: {{ $key | upper }}
    value: {{ pluck $.Values.global.env $map | first | default $map._default | quote }}
  {{- else if pluck $.Values.global.env $map }}
  - name: {{ $key | upper }}
    value: {{ pluck $.Values.global.env $map | first | quote }}
  {{- end }}
{{- end -}}
{{- else }}
{{- range $key, $value := .Values.application.env }}
  - name: {{ $key | upper }}
    value: {{ $value | upper }}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Get secrets from values
*/}}
{{- define "common.env.secretRef" -}}
{{- if .Values.global.env }}
{{- $name := include "common.names.fullname" . }}
{{- range $key, $map := .Values.application.secret -}}
  {{- if $map._default }}
  - name: {{ $key | upper }}
    valueFrom:
      secretKeyRef:
        key: {{ pluck $.Values.global.env $map | first | default $map._default | quote }}
        name: {{ $name }}
  {{- else if pluck $.Values.global.env $map }}
  - name: {{ $key | upper }}
    valueFrom:
      secretKeyRef:
        key: {{ pluck $.Values.global.env $map | first | quote }}
        name: {{ $name }}
  {{- end }}
{{- end }}
{{- else }}
{{- $name := include "common.names.fullname" . }}
{{- range $key, $value := .Values.application.secret }}
  - name: {{ $key | upper }}
  valueFrom:
    secretKeyRef:
    key: {{ $value | upper }}
    name: {{ $name }}
{{- end }}
{{- end -}}
{{- end -}}

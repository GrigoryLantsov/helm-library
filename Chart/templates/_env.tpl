# vi:syntax=yaml
# vi:filetype=yaml

{{/*
Get envs from values
*/}}
{{- define "common.env.envs" -}}
{{- if .Values.global.env }}
{{- range $key, $map := .Values.application.env }}
  - name: {{ $key | upper }}
    value: {{ pluck $.Values.global.env $map | first | default $map._default | quote }}
{{- end -}}
{{- else }}
{{- range $key, $value := .Values.application.env }}
  - name: {{ $key | upper }}
    value: {{ $value | upper }}
{{- end -}}
{{- end -}}
{{- end -}}

{{- define "common.env.envSecretVars" -}}
{{- $fullName := include "java-app.fullname" . -}}
{{- range $key, $map := .Values.application.secret }}
  - secretRef:
      name: {{ $fullName }}-{{ $key | replace "_" "-" }}
{{- end }}
{{- end }}

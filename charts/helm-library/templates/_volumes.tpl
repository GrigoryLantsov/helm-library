# vi:syntax=yaml
# vi:filetype=yaml

{{- define "common.volumes.volumes" }}
  - name: {{ include "common.names.fullname" . }}
    configMap:
      name: {{ include "common.names.fullname" . }}
{{- end }}

{{- define "common.volumes.volumeMounts" }}
  - name: {{ include "common.names.fullname" . }}
    mountPath: {{ .Values.volumeMounts.mountPath }}
    {{- if .Values.volumeMounts.subPath }}
    subPath: {{ .Values.volumeMounts.subPath }}
    {{- end }}
{{- end }}

{{- define "common.volumes.extravolumes" }}
{{- range $key := .Values.volumes.extraVolumes }}
  - name: {{ $key.name }}
    {{- if eq $key.kind "secret" }}
    secret:
      secretName: {{ $key.secret }}
    {{- else if eq $key.kind "configMap" }}
    configMap:
      name: {{ $key.configmap }}
    {{- end }}
{{- end }}
{{- end }}

{{- define "common.volumes.extravolumeMounts" }}
{{- range $key := .Values.volumes.extraVolumes }}
  - name: $key.name
    mountPath: $key.mountpath
{{- end }}
{{- end }}

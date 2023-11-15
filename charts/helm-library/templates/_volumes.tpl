# vi:syntax=yaml
# vi:filetype=yaml

{{- define "common.volumes.volumes" }}
  - name: {{ include "common.names.fullname" . }}
    configMap:
      name: {{ include "common.names.fullname" . }}
{{- end }}

{{- define "common.volumes.volumeMounts" }}
  - name: {{ include "common.names.fullname" . }}
    mountPath: {{ .Values.volumes.path }}
    {{- if .Values.volumes.subpath }}
    subPath: {{ .Values.volumes.subpath }}
    {{- end }}
{{- end }}

{{- define "common.volumes.extravolumes" }}
{{- range $key := .Values.volumes.extraVolumes }}
  - name: $key.name
    configMap:
      name: $key.configmap
{{- end }}
{{- end }}

{{- define "common.volumes.extravolumeMounts" }}
{{- range $key := .Values.volumes.extraVolumes }}
  - name: $key.name
    mountPath: $key.mountpath
{{- end }}
{{- end }}

{{- define "common.volumes.secrets" }}
{{- if .Values.extsecret.enabled }}
  - name: {{ include "common.names.fullname" . }}
    secret:
      secretName: {{ include "common.names.fullname" . }}
{{- end }}
{{- end }}

{{- define "common.volumes.secretMounts" }}
{{- if .Values.extsecret.enabled }}
  - name: {{ include "common.names.fullname" . }}
    mountPath: {{ .Values.extsecret.localpath }}
    {{- if .Values.extsecret.localsubpath }}
    subPath: {{ .Values.extsecret.localsubpath }}
    {{- end }}
{{- end }}
{{- end }}

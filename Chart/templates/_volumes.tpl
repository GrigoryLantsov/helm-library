# vi:syntax=yaml
# vi:filetype=yaml

{{- define "common.volumes.volumes" }}
  - name: application-properties
    configMap:
      name: {{ include "common.names.fullname" . }}
{{- end }}

{{- define "common.volumes.volumeMounts" }}
  - name: application-properties
    mountPath: /opt/application.properties
{{- end }}

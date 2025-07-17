# vi:syntax=yaml
# vi:filetype=yaml

{{- define "node-app.volumes" }}
  - name: application-properties
    configMap:
      name: {{ include "common.names.fullname" . }}-application-yaml
{{- end }}

{{- define "node-app.volumeMounts" }}
  - name: application-properties
    mountPath: /opt/application.properties
{{- end }}

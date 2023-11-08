{{/* vim: set filetype=mustache: */}}
{{/*
Include NOTES.txt of the Charts
*/}}
{{- define "common.notes.final" -}}
Thank you for installing {{ .Chart.Name }}!

Here's some information about the chart you installed:

- Name: {{ .Chart.Name }}
- Version: {{ .Chart.Version }}
- Description: {{ .Chart.Description }}
- AppVersion: {{ .Chart.AppVersion }}
{{- if .Chart.Maintainers }}
{{- range $name := .Chart.Maintainers }}
- Maintainers: {{ . }}
{{- end }}
{{- end }}

Get the application URL by running these commands:
{{- if or .Values.ingress.nginx.enabled .Values.ingress.traefik.enabled .Values.ingress.enabled }}
{{- range $name, $map := .Values.ingress.hosts }}
{{- $hosts := pluck $.Values.global.env $map.host | first | default $map.host._default }}
  {{- range .paths }}
  URL_PARSE:
  {{- $parsedURL := urlParse (printf "https://%s%s" $hosts .path) }}
  {{- if $parsedURL }}
    URL: https://{{ $hosts }}{{ .path }}
    Scheme: {{ $parsedURL.scheme }}
    Host: {{ $parsedURL.host }}
    Path: {{ $parsedURL.path }}
    Userinfo: {{ $parsedURL.userinfo }}
  {{- else }}
    URL: {{ $hosts }}{{ .path }}
  {{- end }}
  {{- end }}
{{- end }}
{{- else if contains "NodePort" .Values.service.type }}
  export NODE_PORT=$(kubectl get --namespace {{ .Release.Namespace }} -o jsonpath="{.spec.ports[0].nodePort}" services {{ include "common.names.fullname" . }})
  export NODE_IP=$(kubectl get nodes --namespace {{ .Release.Namespace }} -o jsonpath="{.items[0].status.addresses[0].address}")
  echo http://$NODE_IP:$NODE_PORT
{{- else if contains "LoadBalancer" .Values.service.type }}
     NOTE: It may take a few minutes for the LoadBalancer IP to be available.
           You can watch the status of by running 'kubectl get --namespace {{ .Release.Namespace }} svc -w {{ include "common.names.fullname" . }}'
  export SERVICE_IP=$(kubectl get svc --namespace {{ .Release.Namespace }} {{ include "common.names.fullname" . }} --template "{{"{{ range (index .status.loadBalancer.ingress 0) }}{{.}}{{ end }}"}}")
  echo http://$SERVICE_IP:{{ .Values.service.port }}
{{- else if contains "ClusterIP" .Values.service.type }}
  export POD_NAME=$(kubectl get pods --namespace {{ .Release.Namespace }} -l "app.kubernetes.io/name={{ include "common.names.fullname" . }},app.kubernetes.io/instance={{ .Release.Name }}" -o jsonpath="{.items[0].metadata.name}")
  export CONTAINER_PORT=$(kubectl get pod --namespace {{ .Release.Namespace }} $POD_NAME -o jsonpath="{.spec.containers[0].ports[0].containerPort}")
  echo "Visit http://127.0.0.1:8080 to use your application"
  kubectl --namespace {{ .Release.Namespace }} port-forward $POD_NAME 8080:$CONTAINER_PORT
{{- end }}
{{- end -}}

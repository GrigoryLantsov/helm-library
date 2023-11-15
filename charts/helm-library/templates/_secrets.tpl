{{/* vim: set filetype=mustache: */}}
{{/*
Deployment volume for secret

Usage:
{{- include "common.secrets.volumes" . }}
*/}}

{{- define "common.secrets.volumes" -}}
- name: {{ include "common.names.fullname" $ }}-vault-secrets
  csi:
    driver: secrets-store.csi.k8s.io
    readOnly: true
    volumeAttributes:
      secretProviderClass: {{ include "common.names.fullname" $ }}
{{- end -}}

{{/*
Deployment volumeMounts for secret

Usage:
{{- include "common.secrets.volumeMounts" . }}
*/}}

{{- define "common.secrets.volumeMounts" -}}
- name: {{ include "common.names.fullname" $ }}-vault-secrets
  mountPath: /mnt/secrets-store
  readOnly: true
{{- end -}}

{{/*
Deployment serviceAccount for secret

Usage:
{{- include "common.secrets.serviceAccount" . }}
*/}}

{{- define "common.secrets.serviceAccount" -}}
serviceAccountName: {{ .Values.secrets.sa }}
{{- end -}}

{{/*
Deployment secretRef for environment

Usage:
{{- include "common.secrets.secretRef" . }}
*/}}

{{- define "common.secrets.secretEnv" }}
{{- $env := default "_default" $.Values.global.env }}
{{- range $objects := .Values.secrets.path }}
{{- $path := "" }}
{{- $key := "" }}
{{- if kindIs "map" $objects.path }}
  {{- $path = default (index $objects.path $env) (index $objects.path "_default") }}
{{- else }}
  {{- $path = index $objects.path $env }}
{{- end }}
{{- if kindIs "map" $objects.key }}
  {{- $key = default (index $objects.key $env) (index $objects.key "_default") }}
{{- else }}
  {{- $key = $objects.key }}
{{- end }}
{{- if and $path $key }}
- name: {{ $objects.name }}
  value: vault:{{ $path }}#{{ $key }}
{{- end }}
{{- end }}
{{- end }}


{{/*
Annotation secret annotations

Usage:
{{- include "common.secrets.annotations" . }}
*/}}

{{- define "common.secrets.annotations" }}
vault.security.banzaicloud.io/vault-role: "{{ .Values.secrets.rolename }}"
vault.security.banzaicloud.io/vault-serviceaccount: "{{ .Values.secrets.sa }}"
{{- end -}}

{{/*
SecretRef File Volume

Usage:
{{- include "common.secrets.file.volume" . }}
*/}}

{{- define "common.secrets.file.volume" }}
{{- range $objects := .Values.secrets.file.path }}
- name: {{ $objects.name }}
  secret:
    secretName: {{ include "common.names.fullname" $ }}-vault
{{- end }}
{{- end }}

{{/*
SecretRef File volumeMounts

Usage:
{{- include "common.secrets.file.volumeMounts" . }}
*/}}

{{- define "common.secrets.file.volumeMounts" }}
{{- range $objects := .Values.secrets.file.path }}
- name: {{ $objects.name }}
  mountPath: {{ $objects.mountPath }}
  subPath: {{ $objects.subPath }}
  readOnly: true
{{- end }}
{{- end }}

{{/*
File Secret

Usage:
{{- include "common.secrets.file.secret" . }}
*/}}

{{- define "common.secrets.file.secret" }}
{{- if $.Values.secrets.enabled }}
{{- $env := default "_default" $.Values.global.env }}
{{- range $objects := .Values.secrets.file.path }}
{{- $path := "" }}
{{- if kindIs "map" $objects.path }} {{/* check if path is a dictionary */}}
  {{- $path = default (index $objects.path "_default") (index $objects.path $env) }}
{{- else }} {{/* if not, use it directly */}}
  {{- $path = $objects.path }}
{{- end }}
{{- $key := "" }}
{{- if kindIs "map" $objects.key }} {{/* same thing for key */}}
  {{- $key = default (index $objects.key "_default") (index $objects.key $env) }}
{{- else }}
  {{- $key = $objects.key }}
{{- end }}
  {{ $objects.subPath }}: {{ printf "vault:%s#%s" $path $key | b64enc }}
{{- end }}
{{- end }}
{{- end }}


{{/*
Deployment secretRef for environment

Usage:
{{- include "common.extsecrets.secretRef" . }}
*/}}

{{- define "common.secrets.secretEnv" }}
{{- $env := default "_default" $.Values.global.env }}
{{- range $objects := .Values.secrets.path }}
{{- $path := "" }}
{{- $key := "" }}
{{- if kindIs "map" $objects.path }}
  {{- $path = default (index $objects.path $env) (index $objects.path "_default") }}
{{- else }}
  {{- $path = index $objects.path $env }}
{{- end }}
{{- if kindIs "map" $objects.key }}
  {{- $key = default (index $objects.key $env) (index $objects.key "_default") }}
{{- else }}
  {{- $key = $objects.key }}
{{- end }}
{{- if and $path $key }}
- name: {{ $objects.name }}
  value: vault:{{ $path }}#{{ $key }}
{{- end }}
{{- end }}
{{- end }}

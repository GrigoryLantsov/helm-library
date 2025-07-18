{{/* vim: set filetype=mustache: */}}

{{/*
Return a soft nodeAffinity definition
{{ include "common.affinities.nodes.soft" (dict "key" "FOO" "values" (list "BAR" "DOM")) -}}
*/}}
{{- define "common.affinities.nodes.soft" }}
preferredDuringSchedulingIgnoredDuringExecution:
  - preference:
      matchExpressions:
        - key: {{ .key }}
          operator: In
          values:
            {{- range .values }}
            - {{ . | quote }}
            {{- end }}
    weight: 1
{{- end }}

{{/*
Return a hard nodeAffinity definition
{{ include "common.affinities.nodes.hard" (dict "key" "FOO" "values" (list "BAR" "DOM")) -}}
*/}}
{{- define "common.affinities.nodes.hard" }}
requiredDuringSchedulingIgnoredDuringExecution:
  nodeSelectorTerms:
    - matchExpressions:
        - key: {{ .key }}
          operator: In
          values:
            {{- range .values }}
            - {{ . | quote }}
            {{- end }}
{{- end }}

{{/*
Return a nodeAffinity definition
{{ include "common.affinities.nodes" (dict "type" "soft" "key" "FOO" "values" (list "BAR" "DOM")) -}}
*/}}
{{- define "common.affinities.nodes" }}
{{- if eq .type "soft" }}
  {{- include "common.affinities.nodes.soft" . }}
{{- else if eq .type "hard" }}
  {{- include "common.affinities.nodes.hard" . }}
{{- end }}
{{- end }}

{{/*
Return a topologyKey definition
{{ include "common.affinities.topologyKey" (dict "topologyKey" "BAR") -}}
*/}}
{{- define "common.affinities.topologyKey" }}
{{- .topologyKey | default "kubernetes.io/hostname" }}
{{- end }}

{{/*
Return a soft podAffinity/podAntiAffinity definition
{{ include "common.affinities.pods.soft" (dict "component" "FOO" "extraMatchLabels" .Values.extraMatchLabels "topologyKey" "BAR" "context" $) -}}
*/}}
{{- define "common.affinities.pods.soft" }}
{{- $component := default "" .component }}
{{- $extraMatchLabels := default (dict) .extraMatchLabels }}
preferredDuringSchedulingIgnoredDuringExecution:
  - podAffinityTerm:
      labelSelector:
        matchLabels:
          {{- (include "common.labels.matchLabels" .context) | indent 10 }}
          {{- if not (empty $component) }}
            {{ printf "app.kubernetes.io/component: %s" $component }}
          {{- end }}
          {{- range $key, $value := $extraMatchLabels }}
          {{ $key }}: {{ $value | quote }}
          {{- end }}
      topologyKey: {{ include "common.affinities.topologyKey" (dict "topologyKey" .topologyKey) }}
    weight: 1
{{- end }}

{{/*
Return a hard podAffinity/podAntiAffinity definition
{{ include "common.affinities.pods.hard" (dict "component" "FOO" "extraMatchLabels" .Values.extraMatchLabels "topologyKey" "BAR" "context" $) -}}
*/}}
{{- define "common.affinities.pods.hard" }}
{{- $component := default "" .component }}
{{- $extraMatchLabels := default (dict) .extraMatchLabels }}
requiredDuringSchedulingIgnoredDuringExecution:
  - labelSelector:
      matchLabels:
        {{- (include "common.labels.matchLabels" .context) | indent 8 }}
        {{- if not (empty $component) }}
          {{ printf "app.kubernetes.io/component: %s" $component }}
        {{- end }}
        {{- range $key, $value := $extraMatchLabels }}
        {{ $key }}: {{ $value | quote }}
        {{- end }}
    topologyKey: {{ include "common.affinities.topologyKey" (dict "topologyKey" .topologyKey) }}
{{- end }}

{{/*
Return a podAffinity/podAntiAffinity definition
{{ include "common.affinities.pods" (dict "type" "soft" "key" "FOO" "values" (list "BAR" "BAZ")) -}}
*/}}
{{- define "common.affinities.pods" }}
{{- if eq .type "soft" }}
  {{- include "common.affinities.pods.soft" . }}
{{- else if eq .type "hard" }}
  {{- include "common.affinities.pods.hard" . }}
{{- end }}
{{- end }}

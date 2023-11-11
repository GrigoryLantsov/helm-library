# Common

## Introduction

This chart provides a universal chart for every kind of applications

## Usage

*Use chart as dependency:*

```yaml
dependencies:
  - name: helm-library
    version: 3.0.3
    repository: https://grigorylantsov.github.io/helm-library/
```

```sh
  helm dependency build
```

*Use reference like:*

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ include "common.names.fullname" . }}
data:
  myvalue: "MyKey"
```

## Overview

### Affinity

Manage affinities in your deployment

```yaml
# values.yaml
affinity:
  enabled: true
podAffinityPreset: ""
podAntiAffinityPreset: soft
nodeAffinityPreset:
  type: "soft"
  key: "kubernetes.io/hostname"
  values:
    - node-1
    - node-2

# deployment.yaml
{{- if .Values.affinity.enabled }}
affinity:
  podAffinity: {{- include "common.affinities.pods" (dict "type" .Values.podAffinityPreset "context" $) | nindent 10 }}
  podAntiAffinity: {{- include "common.affinities.pods" (dict "type" .Values.podAntiAffinityPreset "context" $) | nindent 10 }}
  nodeAffinity: {{- include "common.affinities.nodes" (dict "type" .Values.nodeAffinityPreset.type "key" .Values.nodeAffinityPreset.key "values" .Values.nodeAffinityPreset.values) | nindent 10 }}
{{- end }}
```

### Capabilities

You can set capabilities in **policy**, **networkPolicy**, **cronjob**, **deployment**, **statefulset**, **ingress**, **rbac**, **crd**, **apiVersion**, **hpa**

```yaml
apiVersion: {{ include "common.capabilities.ingress.apiVersion" . }}
```

### Images

```yaml
# values.yaml
registry: registry
repository: test
tag: release-1
pullPolicy: Always
debug: false

# deployment
{{- include "common.images.image" (dict "imageRoot" .Values.image "global" .Values.global) -}}
```


## TODO
Other documentation for .tpl files

[Github](https://github.com/GrigoryLantsov)
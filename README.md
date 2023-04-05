# Common

## Introduction

This chart provides a common template helpers

## Usage

*Use chart as dependency:*

```yaml
dependencies:
  - name: helm-library
    version: 0.1.0
    repository: https://github.com/GrigoryLantsov/helm-library/common
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
    - ct-dev-kube-node-8
    - ct-dev-kube-node-9

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
registry: ct-prod-nexus.priv:4000
repository: realty/backend/broker/mb-agent
tag: dev.a376329e
pullPolicy: Always
debug: false

# deployment
{{- include "common.images.image" (dict "imageRoot" .Values.image "global" .Values.global) -}}
```


## TODO
Other documentation for .tpl files


# python

## Debug

Example:

```
diagnosticMode:
  enabled: false

command: ["/start"]

job:
  enabled: false

livenessProbe:
  enabled: false
  path: /self
readinessProbe:
  enabled: false
  path: /ready
startupProbe:
  enabled: False

image:
  repository: node
  tag: 19.7.0-slim
  digest: ""
  pullPolicy: IfNotPresent
  pullSecrets: []
  debug: false

containerPorts:
  http: 8080

podAnnotations:

autoscaling:
  enabled: false

replicaCount:
  _default: 1
  dev: 1

volumes:
  enabled: false
#  path: /app/appsettings.json
#  subpath: appsettings.json

affinity: {}

podSecurityContext:
  enabled: false
containerSecurityContext:
  enabled: false

resources:
  limits:
    cpu: 1000m
    memory: 2048Mi
  requests:
    cpu: 200m
    memory: 500Mi

service:
  type: ClusterIP
  ports:
    http: 8080
  nodePorts:
    http: {}

ingress:
  enabled: false

serviceAccount:
  create: false

persistence:
  enabled: true
  size: 50
  bucket: k8s-dev-pv/
  accessModes:
    - ReadWriteMany
  path: /test/media

extsecret:
  enabled: true
  single:
    enabled: true
  multiple:
    enabled: false
  list:
    - key:
        dev: fasd
      path: REDIS_SECRET
    - key:
        dev: 1234
      path: UPLOADER_POSTGRES_USER
    - key:
        dev: sgda
      path: UPLOADER_POSTGRES_PASSWORD

application:
  env:
    REDIS_URL:
      dev: redis://redis:6379
  secret:
    SECRET_KEY:
      dev: REDIS_SECRET
    POSTGRES_DB:
      dev: UPLOADER_POSTGRES_USER
    POSTGRES_USER:
      dev: UPLOADER_POSTGRES_USER
    POSTGRES_PASSWORD:
      dev: UPLOADER_POSTGRES_PASSWORD
```

## TODO

1. Create documentation for that Chart

Just confirm that the chart is worked:
```sh
helm template python-app . --set global.env=dev --debug -f values.yaml
install.go:192: [debug] Original chart version: ""

---
# Source: python-app/templates/service.yaml
apiVersion: v1
kind: Service
metadata:
  name: python-app-python-app
  namespace: "ins-stage"
  labels:
    app.kubernetes.io/name: python-app
    helm.sh/chart: python-app-0.1.0
    app.kubernetes.io/instance: python-app
    app.kubernetes.io/managed-by: Helm
spec:
  type: ClusterIP
  sessionAffinity: None
  ports:
    - name: http
      port: 80
      targetPort: http
      pythonPort: null
  selector:
    app.kubernetes.io/name: python-app
    app.kubernetes.io/instance: python-app
---
# Source: python-app/templates/deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: python-app-python-app
  namespace: "ins-stage"
  labels:
    app.kubernetes.io/name: python-app
    helm.sh/chart: python-app-0.1.0
    app.kubernetes.io/instance: python-app
    app.kubernetes.io/managed-by: Helm
spec:
  selector:
    matchLabels:
      app.kubernetes.io/name: python-app
      app.kubernetes.io/instance: python-app
  replicas: 1
  template:
    metadata:
      labels:
        app.kubernetes.io/name: python-app
        helm.sh/chart: python-app-0.1.0
        app.kubernetes.io/instance: python-app
        app.kubernetes.io/managed-by: Helm
    spec:
      containers:
        - name: python-app-python-app
          image: docker.io/python:19.7.0-slim
          imagePullPolicy: "IfNotPresent"
          env:        
          - name: FOO
            value: barr
          envFrom:
          ports:
            - name: http
              containerPort: 3000
---
# Source: python-app/templates/ingress.yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: python-app-python-app
  namespace: "ins-stage"
  labels:
    app.kubernetes.io/name: python-app
    helm.sh/chart: python-app-0.1.0
    app.kubernetes.io/instance: python-app
    app.kubernetes.io/managed-by: Helm
  annotations:
    kubernetes.io/ingress.class: nginx
    nginx.ingress.kubernetes.io/proxy-body-size: 200m
    nginx.ingress.kubernetes.io/proxy-read-timeout: "600"
    nginx.ingress.kubernetes.io/proxy-send-timeout: "600"
spec:
  rules:
    - host: example.com
      http:
        paths:
          - path: /example/api/v1
            pathType: Prefix
            backend:
              service:
                name: python-app-python-app
                port:
                  number: 80
    - host: dev.example.com
      http:
        paths:
          - path: /example/swagger
            pathType: Prefix
            backend:
              service:
                name: python-app-python-app
                port:
                  number: 80

```

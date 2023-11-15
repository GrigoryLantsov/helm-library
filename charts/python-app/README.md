
# python

## Debug

Если возникает ошибка в джобе хельма связанная с самим чартом (expected key or smth), то локально подменяйте values файл на свой, запустите команду:
```sh
helm template . --debug --set global.env=dev
```

**Не забудьте откатить изменения values перед коммитом в репу!**

## TODO

1. Test Chart on multiple npm repositories
2. Create documentation for that Chart

Just confirm that the chart is worked:
```sh
helm template python-app . --set global.env=dev --debug -f values.yaml
install.go:192: [debug] Original chart version: ""
```

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
          - path: /admin-panel/api/v1
            pathType: Prefix
            backend:
              service:
                name: python-app-python-app
                port:
                  number: 80
    - host: dev.example.com
      http:
        paths:
          - path: /admin-panel/swagger
            pathType: Prefix
            backend:
              service:
                name: python-app-python-app
                port:
                  number: 80

```

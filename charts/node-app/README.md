
# Node

## Debug

Если возникает ошибка в джобе хельма связанная с самим чартом (expected key or smth), то локально подменяйте values файл на свой, запустите команду:
```sh
helm template . --debug --set global.env=dev
```

Возможно добавить придется те сущности которые были указаны в основном values и вы сможете отдебажить проблему связанную с чартом.

**Не забудьте откатить изменения values перед коммитом в репу!**

## TODO

1. Test Chart on multiple npm repositories
2. Create documentation for that Chart

Just confirm that the chart is worked:
```sh
helm template node-app . --set global.env=dev --debug -f values.yaml
install.go:192: [debug] Original chart version: ""

---
# Source: node-app/templates/service.yaml
apiVersion: v1
kind: Service
metadata:
  name: node-app-node-app
  namespace: "ins-stage"
  labels:
    app.kubernetes.io/name: node-app
    helm.sh/chart: node-app-0.1.0
    app.kubernetes.io/instance: node-app
    app.kubernetes.io/managed-by: Helm
spec:
  type: ClusterIP
  sessionAffinity: None
  ports:
    - name: http
      port: 80
      targetPort: http
      nodePort: null
  selector:
    app.kubernetes.io/name: node-app
    app.kubernetes.io/instance: node-app
---
# Source: node-app/templates/deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: node-app-node-app
  namespace: "ins-stage"
  labels:
    app.kubernetes.io/name: node-app
    helm.sh/chart: node-app-0.1.0
    app.kubernetes.io/instance: node-app
    app.kubernetes.io/managed-by: Helm
spec:
  selector:
    matchLabels:
      app.kubernetes.io/name: node-app
      app.kubernetes.io/instance: node-app
  replicas: 1
  template:
    metadata:
      labels:
        app.kubernetes.io/name: node-app
        helm.sh/chart: node-app-0.1.0
        app.kubernetes.io/instance: node-app
        app.kubernetes.io/managed-by: Helm
    spec:
      containers:
        - name: node-app-node-app
          image: docker.io/node:19.7.0-slim
          imagePullPolicy: "IfNotPresent"
          env:        
          - name: FOO
            value: barr
          envFrom:
          ports:
            - name: http
              containerPort: 3000
---
# Source: node-app/templates/ingress.yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: node-app-node-app
  namespace: "ins-stage"
  labels:
    app.kubernetes.io/name: node-app
    helm.sh/chart: node-app-0.1.0
    app.kubernetes.io/instance: node-app
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
                name: node-app-node-app
                port:
                  number: 80
    - host: dev.example.com
      http:
        paths:
          - path: /admin-panel/swagger
            pathType: Prefix
            backend:
              service:
                name: node-app-node-app
                port:
                  number: 80

```

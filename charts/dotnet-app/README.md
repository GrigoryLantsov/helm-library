# Dotnet

## Debug

Если возникает ошибка в джобе хельма связанная с самим чартом (expected key or smth), то локально подменяйте values файл на свой, запустите команду:
```sh
helm template . --debug --set global.env=dev
```

**Не забудьте откатить изменения values перед коммитом в репу!**

## TODO

1. Test Chart on multiple dotnet repositories
2. Create documentation for that Chart

Just confirm that the chart is worked:
```sh
helm template dotnet-app . --set global.env=dev --debug
```

---
# Source: dotnet-app/templates/service.yaml
apiVersion: v1
kind: Service
metadata:
  name: dotnet-app
  namespace: "test"
  labels:
    app.kubernetes.io/name: dotnet-app
    helm.sh/chart: dotnet-app-0.1.0
    app.kubernetes.io/instance: dotnet-app
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
    app.kubernetes.io/name: dotnet-app
    app.kubernetes.io/instance: dotnet-app
---
# Source: dotnet-app/templates/deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: dotnet-app
  namespace: "test"
  labels:
    app.kubernetes.io/name: dotnet-app
    helm.sh/chart: dotnet-app-0.1.0
    app.kubernetes.io/instance: dotnet-app
    app.kubernetes.io/managed-by: Helm
spec:
  selector:
    matchLabels:
      app.kubernetes.io/name: dotnet-app
      app.kubernetes.io/instance: dotnet-app
  replicas: 1
  template:
    metadata:
      labels:
        app.kubernetes.io/name: dotnet-app
        helm.sh/chart: dotnet-app-0.1.0
        app.kubernetes.io/instance: dotnet-app
        app.kubernetes.io/managed-by: Helm
    spec:
      containers:
        - name: dotnet-app
          image: node:19.7.0-slim
          imagePullPolicy: "IfNotPresent"
          ports:
            - name: http
              containerPort: 3000
---
# Source: dotnet-app/templates/tests/test-connection.yaml
apiVersion: v1
kind: Pod
metadata:
  name: "dotnet-app-test-connection"
  labels:
    app.kubernetes.io/name: dotnet-app
    helm.sh/chart: dotnet-app-0.1.0
    app.kubernetes.io/instance: dotnet-app
    app.kubernetes.io/managed-by: Helm
  annotations:
    "helm.sh/hook": test
spec:
  containers:
    - name: wget
      image: busybox
      command: ['wget']
      args: ['dotnet-app:80']
  restartPolicy: Never
```

resource "kubernetes_manifest" "taki-deployment" {
  manifest = yamldecode(<<YAML
apiVersion: apps/v1
kind: Deployment
metadata:
  name: taki-deployment
spec:
  replicas: 1
  selector:
    matchLabels:
      app: taki
  template:
    metadata:
      labels:
        app: taki
    spec:
      containers:
      - name: taki
        image: yuni2/taki:latest
        imagePullPolicy: Always
        resources:
          limits:
            memory: "128Mi"
            cpu: "500m"
        ports:
        - containerPort: 8080
YAML
  )
  depends_on = [
    kubernetes_namespace.social-hub-ns
  ]
}

resource "kubernetes_manifest" "taki-service" {
  manifest = yamldecode(<<YAML
apiVersion: v1
kind: Service
metadata:
  name: taki-service
spec:
  selector:
    app: taki
  ports:
  - port: 8080
    targetPort: 8080
YAML
  )
  depends_on = [
    kubernetes_namespace.social-hub-ns
  ]
}

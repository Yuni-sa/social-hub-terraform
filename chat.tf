resource "kubernetes_manifest" "chat-deployment" {
  manifest = yamldecode(<<YAML
apiVersion: apps/v1
kind: Deployment
metadata:
  name: golang-chat-deployment
  namespace: ${var.socialhub-namespace}
spec:
  replicas: 1
  selector:
    matchLabels:
      app: golang-chat
  template:
    metadata:
      labels:
        app: golang-chat
    spec:
      containers:
      - name: backend
        image: yuni2/golang-chat:latest
        imagePullPolicy: Always
        resources:
          limits:
            memory: "128Mi"
            cpu: "500m"
        ports:
        - containerPort: 8000
YAML
  )
  depends_on = [
    kubernetes_namespace.social-hub-ns
  ]
}

resource "kubernetes_manifest" "chat-service" {
  manifest = yamldecode(<<YAML
apiVersion: v1
kind: Service
metadata:
  name: golang-chat-service
  namespace: ${var.socialhub-namespace}
spec:
  selector:
    app: golang-chat
  ports:
  - port: 8000
    targetPort: 8000
YAML
  )
  depends_on = [
    kubernetes_namespace.social-hub-ns
  ]
}

resource "kubernetes_manifest" "auth-deployment" {
  manifest = yamldecode(<<YAML
apiVersion: apps/v1
kind: Deployment
metadata:
  name: golang-auth-deployment
  namespace: ${var.socialhub-namespace}
spec:
  replicas: 1
  selector:
    matchLabels:
      app: golang-auth
  template:
    metadata:
      labels:
        app: golang-auth
    spec:
      containers:
      - name: golang-auth
        image: yuni2/golang-auth:latest
        imagePullPolicy: Always
        resources:
          limits:
            memory: "128Mi"
            cpu: "500m"
        ports:
        - containerPort: 4000
YAML
  )
  depends_on = [
    kubernetes_namespace.social-hub-ns
  ]
}

resource "kubernetes_manifest" "auth-service" {
  manifest = yamldecode(<<YAML
apiVersion: v1
kind: Service
metadata:
  name: golang-auth-service
  namespace: ${var.socialhub-namespace}
spec:
  selector:
    app: golang-auth
  ports:
  - port: 4000
    targetPort: 4000
YAML
  )
  depends_on = [
    kubernetes_namespace.social-hub-ns
  ]
}

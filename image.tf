resource "kubernetes_manifest" "image-deployment" {
  manifest = yamldecode(<<YAML
apiVersion: apps/v1
kind: Deployment
metadata:
  name: golang-image-deployment
  namespace: ${var.socialhub-namespace}
spec:
  replicas: 1
  selector:
    matchLabels:
      app: golang-image
  template:
    metadata:
      labels:
        app: golang-image
    spec:
      containers:
      - name: golang-image
        image: yuni2/golang-image:latest
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

resource "kubernetes_manifest" "image-service" {
  manifest = yamldecode(<<YAML
apiVersion: v1
kind: Service
metadata:
  name: golang-image-service
  namespace: ${var.socialhub-namespace}
spec:
  selector:
    app: golang-image
  ports:
  - port: 4000
    targetPort: 4000
YAML
  )
  depends_on = [
    kubernetes_namespace.social-hub-ns
  ]
}

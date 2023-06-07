resource "kubernetes_manifest" "frontend-deployment" {
  manifest = yamldecode(<<YAML
apiVersion: apps/v1
kind: Deployment
metadata:
  name: react-frontend-deployment
  namespace: social-hub
spec:
  replicas: 1
  selector:
    matchLabels:
      app: react-frontend
  template:
    metadata:
      labels:
        app: react-frontend
    spec:
      containers:
      - name: react-frontend
        image: yuni2/react-frontend:latest
        imagePullPolicy: Always
        resources:
          limits:
            memory: "512Mi"
            cpu: "800m"
        ports:
        - containerPort: 3000
YAML
  )
  depends_on = [
    kubernetes_namespace.social-hub-ns
  ]
}

resource "kubernetes_manifest" "frontend-service" {
  manifest = yamldecode(<<YAML
apiVersion: v1
kind: Service
metadata:
  name: react-frontend-service
  namespace: social-hub
spec:
  selector:
    app: react-frontend
  ports:
  - port: 3000
    targetPort: 3000
YAML
  )
  depends_on = [
    kubernetes_namespace.social-hub-ns
  ]
}

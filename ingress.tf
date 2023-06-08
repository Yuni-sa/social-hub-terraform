resource "kubernetes_manifest" "ingress" {
  manifest = yamldecode(<<YAML
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /$1
  name: socialhub-ingress
  namespace: ${var.socialhub-namespace}
spec:
  rules:
    - host: socialhub.com
      http:
        paths:
          - path: /taki/*
            pathType: Prefix
            backend:
              service:
                name: taki-service
                port:
                  number: 8080
          - path: /socket.io/*
            pathType: Prefix
            backend:
              service:
                name: taki-service
                port:
                  number: 8080
          - path: /websocket
            pathType: Prefix
            backend:
              service:
                name: golang-chat-service
                port:
                 number: 8000
          - path: /api/*
            pathType: Prefix
            backend:
              service:
                name: golang-auth-service
                port:
                 number: 4000
          - path: /api/*
            pathType: Prefix
            backend:
              service:
                name: golang-image-service
                port:
                 number: 4000
          - path: /
            pathType: Prefix
            backend:
              service:
                name: react-frontend-service
                port:
                  number: 3000
YAML
  )
  depends_on = [
    kubernetes_namespace.social-hub-ns
  ]
}

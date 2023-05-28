# Configure Kubernetes provider and connect to the Kubernetes API server
provider "kubernetes" {
  config_path    = "~/.kube/config"
  experiments {
    manifest_resource = true
  }
}

resource "kubernetes_namespace" "social-hub-ns" {
  metadata {
    name = "social-hub"
  }
}
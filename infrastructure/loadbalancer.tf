# This is for , to access our application via LB

data "kubernetes_service_v1" "nginx" {
  metadata {
    name      = "nginx-service"
    namespace = "default"
  }

  depends_on = [
    kubectl_manifest.argocd_application
  ]
}
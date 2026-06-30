provider "kubernetes" {
  host                   = aws_eks_cluster.my-cluster.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.my-cluster.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.my-cluster.token
}

data "kubernetes_secret_v1" "argocd_admin" {
  metadata {
    name      = "argocd-initial-admin-secret"
    namespace = "argocd"
  }

  depends_on = [
    helm_release.argocd
  ]
}

# UI access of argocd
resource "kubernetes_service_v1" "argocd_server" {
  metadata {
    name      = "argocd-server"
    namespace = "argocd"
  }

  spec {
    type = "LoadBalancer"

    selector = {
      "app.kubernetes.io/name" = "argocd-server"
    }

    port {
      port        = 443
      target_port = 8080
    }
  }
}





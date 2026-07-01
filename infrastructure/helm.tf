provider "helm" {
  kubernetes = {
    host                   = aws_eks_cluster.my-cluster.endpoint
    cluster_ca_certificate = base64decode(aws_eks_cluster.my-cluster.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.my-cluster.token
  }
}

data "aws_eks_cluster_auth" "my-cluster" {
  name = aws_eks_cluster.my-cluster.name
}

resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = "argocd"
  create_namespace = true

  depends_on = [aws_eks_node_group.my-workers]
}
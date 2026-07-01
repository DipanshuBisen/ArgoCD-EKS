provider "kubectl" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.cluster.token
  load_config_file       = false
}

data "aws_eks_cluster" "cluster" {
  name = aws_eks_cluster.my-cluster.name
}

data "aws_eks_cluster_auth" "cluster" {
  name = aws_eks_cluster.my-cluster.name
}

resource "kubectl_manifest" "argocd_application" {

  yaml_body = file("${path.module}/../manifest/application.yaml")

  depends_on = [
    helm_release.argocd
  ]
}


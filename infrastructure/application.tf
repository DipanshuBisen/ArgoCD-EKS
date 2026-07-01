provider "kubectl" {
  host                   = aws_eks_cluster.my-cluster.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.my-cluster.certificate_authority[0].data)
  token                  = aws_eks_cluster.my-cluster.token
  load_config_file       = false
}

resource "kubectl_manifest" "argocd_application" {

  yaml_body = file("${path.module}/../manifest/application.yaml")

  depends_on = [
    helm_release.argocd
  ]
}


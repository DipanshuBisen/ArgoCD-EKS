

resource "kubectl_manifest" "argocd_application" {

  yaml_body = file("${path.module}/../manifest/application.yaml")

  depends_on = [
    helm_release.argocd
  ]
}
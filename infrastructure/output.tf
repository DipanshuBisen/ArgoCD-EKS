#UI of argocd 
output "argocd_ui_url" {
  value = try(
    "https://${data.kubernetes_service_v1.argocd_server.status[0].load_balancer[0].ingress[0].hostname}",
    "LoadBalancer is still being provisioned..."
  )
}

# username of argocd
output "argocd_admin_username" {
  value = "admin"
}

#password of argocd
output "argocd_admin_password" {
  value     = data.kubernetes_secret_v1.argocd_admin.data["password"]
  sensitive = true
}


# LB URL to access the application
output "application_url" {
  value = try(
    "http://${data.kubernetes_service_v1.nginx.status[0].load_balancer[0].ingress[0].hostname}",
    "LoadBalancer is still being provisioned..."
  )
}
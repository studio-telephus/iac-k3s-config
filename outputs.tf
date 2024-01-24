output "kubernetes_dashboard_token" {
  value = "kubectl -n kubernetes-dashboard create token kubernetes-dashboard"
}

output "kubernetes_dashboard_url" {
  value = "https://kubernetes-dashboard.${local.cluster_san}"
}

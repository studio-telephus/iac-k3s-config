output "longhorn_dashboard" {
  value = "kubectl -n longhorn-system port-forward service/longhorn-frontend 9999:80"
}

output "kubernetes_dashboard_token" {
  value = "kubectl -n kubernetes-dashboard create token kubernetes-dashboard"
}

output "kubernetes_dashboard_url" {
  value = "https://dashboard.${local.cluster_san}"
}

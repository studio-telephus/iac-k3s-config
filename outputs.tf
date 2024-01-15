output "longhorn_dashboard" {
  value = "kubectl -n longhorn-system port-forward service/longhorn-frontend 9999:80"
}

output "kubernetes_dashboard_token" {
  value = "kubectl -n kubernetes-dashboard create token kubernetes-dashboard"
}

output "kubernetes_dashboard_url" {
  value = "https://dashboard.${local.cluster_san}"
}

output "grafana_admin_password" {
  value = "kubectl -n grafana get secret grafana -o jsonpath='{.data.admin-password}' | base64 -d; echo"
}

output "grafana_url" {
  value = "https://grafana.${local.cluster_san}"
}

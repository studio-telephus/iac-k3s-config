resource "helm_release" "prometheus" {
  count            = var.enable_monitoring ? 1 : 0
  name             = "prometheus"
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "prometheus"
  version          = "19.6.0"
  namespace        = "prometheus"
  create_namespace = "true"
  timeout          = "600"

  set {
    name  = "server.persistentVolume.size"
    value = "15Gi"
  }
  set {
    name  = "alertmanager.persistence.size"
    value = "5Gi"
  }

  values = [
    <<-EOT
    prometheus-node-exporter:
      tolerations:
      - key: node-role.kubernetes.io/master
        operator: Exists
        effect: NoSchedule
      - key: node-role.kubernetes.io/control-plane
        operator: Exists
        effect: NoSchedule
      - key: CriticalAddonsOnly
        operator: Exists
    EOT
  ]

  depends_on = [
    time_sleep.wait_for_longhorn,
    helm_release.cert_manager
  ]
}

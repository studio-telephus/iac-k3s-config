resource "helm_release" "loki" {
  count            = var.enable_logging ? 1 : 0
  name             = "loki"
  repository       = "https://grafana.github.io/helm-charts"
  chart            = "loki"
  version          = "4.10.0"
  namespace        = "loki"
  create_namespace = "true"
  timeout          = "600"
  values = [
    <<-EOT
    loki:
      auth_enabled: false
      commonConfig:
        replication_factor: 1
      compactor:
        retention_enabled: true
      storage:
        type: filesystem
    singleBinary:
      replicas: 1
      persistence:
        size: 20Gi
    monitoring:
      dashboards:
        enabled: false
      rules:
        enabled: false
        alerting: false
      alerts:
        enabled: false
      serviceMonitor:
        enabled: false
      selfMonitoring:
        enabled: false
        grafanaAgent:
          installOperator: false
      lokiCanary:
        enabled: false
    test:
      enabled: false
    EOT
  ]

  depends_on = [
    time_sleep.wait_for_longhorn,
    helm_release.cert_manager
  ]
}

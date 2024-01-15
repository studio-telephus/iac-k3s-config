resource "helm_release" "promtail" {
  count            = var.enable_logging ? 1 : 0
  name             = "promtail"
  repository       = "https://grafana.github.io/helm-charts"
  chart            = "promtail"
  version          = "6.15.3"
  namespace        = "promtail"
  create_namespace = "true"
  values = [
    <<-EOT
    config:
      clients:
      - url: http://loki.loki.svc.${local.cluster_domain}:3100/loki/api/v1/push

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

  depends_on = [helm_release.loki]
}

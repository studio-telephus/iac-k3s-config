resource "helm_release" "kured" {
  count            = var.enable_automatic_node_reboot ? 1 : 0
  name             = "kured"
  repository       = "https://kubereboot.github.io/charts"
  chart            = "kured"
  version          = "4.4.1"
  namespace        = "kube-system"
  create_namespace = "false"
  values = [
    <<-EOT
    podAnnotations:
      prometheus.io/scrape: "true"
      prometheus.io/port: "8080"
    configuration:
      rebootSentinel: "/var/run/reboot-required"
      startTime: "02:00"
      endTime: "05:00"
      rebootDays: [mon,tue,wed,thu]
      timeZone: Local
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
}

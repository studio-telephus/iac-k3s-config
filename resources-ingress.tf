resource "helm_release" "ingress_nginx" {
  count            = 0
  name             = "ingress-controller"
  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  version          = "4.9.0"
  namespace        = "ingress-nginx"
  create_namespace = "true"
  values = [
    <<-EOT
    controller:
      metrics:
        enabled: true
      service:
        annotations:
          prometheus.io/scrape: "true"
          prometheus.io/port: "10254"
        externalIPs:
        - ${local.external_ip[var.env]}
        type: NodePort
        nodePorts:
          http: "30080"
          https: "30443"
    EOT
  ]
}

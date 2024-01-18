//resource "kubernetes_namespace" "ingress_nginx" {
//  metadata {
//    name = "ingress-nginx"
//  }
//}
//
//resource "helm_release" "ingress_nginx" {
//  name             = "ingress-controller"
//  repository       = "https://kubernetes.github.io/ingress-nginx"
//  chart            = "ingress-nginx"
//  version          = "4.9.0"
//  namespace        = "ingress-nginx"
//  create_namespace = "false"
//  values = [
//    <<-EOT
//    controller:
//      metrics:
//        enabled: true
//      service:
//        annotations:
//          prometheus.io/scrape: "true"
//          prometheus.io/port: "10254"
//        externalIPs:
//        - ${local.external_ip[var.env]}
//        type: NodePort
//        nodePorts:
//          http: "30080"
//          https: "30443"
//    EOT
//  ]
//  depends_on = [
//    kubernetes_namespace.ingress_nginx
//  ]
//}

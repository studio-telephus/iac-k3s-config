resource "helm_release" "kubernetes_dashboard" {
  name             = "kubernetes-dashboard"
  repository       = "https://kubernetes.github.io/dashboard/"
  chart            = "kubernetes-dashboard"
  version          = "5.11.0"
  namespace        = "kubernetes-dashboard"
  create_namespace = "true"

  set {
    name  = "metricsScraper.enabled"
    value = "true"
  }
  set {
    name  = "protocolHttp"
    value = "true"
  }
  set {
    name  = "service.externalPort"
    value = "80"
  }

  values = [
    <<-EOT
    extraArgs:
    - --enable-insecure-login
    ingress:
      enabled: true
      className: traefik
      hosts:
      - dashboard.${local.cluster_san}
      tls:
      - secretName: kubernetes-dashboard-tls
        hosts:
        - dashboard.${local.cluster_san}
      annotations:
        cert-manager.io/cluster-issuer: "cm-cluster-issuer"
    EOT
  ]

  depends_on = [
    kubectl_manifest.cm_cluster_issuer,
    helm_release.ingress_nginx,
    helm_release.cert_manager,
  ]
}

resource "kubectl_manifest" "kubernetes_dashboard_cluster_role_binding" {
  yaml_body  = <<-YAML
    apiVersion: rbac.authorization.k8s.io/v1
    kind: ClusterRoleBinding
    metadata:
      name: kubernetes-dashboard
    roleRef:
      apiGroup: rbac.authorization.k8s.io
      kind: ClusterRole
      name: cluster-admin
    subjects:
    - kind: ServiceAccount
      name: kubernetes-dashboard
      namespace: kubernetes-dashboard
    YAML
  depends_on = [helm_release.kubernetes_dashboard]
}

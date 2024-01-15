resource "helm_release" "cert_manager" {
  name             = "cert-manager"
  repository       = "https://charts.jetstack.io"
  chart            = "cert-manager"
  version          = "1.13.3"
  namespace        = "cert-manager"
  create_namespace = "true"
  set {
    name  = "installCRDs"
    value = "true"
  }
  depends_on = [helm_release.ingress_nginx]
}

resource "kubernetes_secret" "cm_secret_ca" {
  metadata {
    name      = "cm-secret-ca"
    namespace = "cert-manager"
  }
  type = "kubernetes.io/tls"
  data = {
    "ca.crt"  = base64decode(module.cm_tls_root_ca_crt.data.notes)
    "tls.crt" = base64decode(module.cm_tls_ca_crt.data.notes)
    "tls.key" = base64decode(module.cm_tls_ca_key.data.notes)
  }
  depends_on = [
    helm_release.cert_manager
  ]
}

resource "kubectl_manifest" "cm_cluster_issuer" {
  yaml_body  = <<-YAML
    apiVersion: cert-manager.io/v1
    kind: ClusterIssuer
    metadata:
      name: cm-cluster-issuer
      namespace: cert-manager
    spec:
      ca:
        secretName: cm-secret-ca
    YAML
  apply_only = true
  depends_on = [
    helm_release.cert_manager,
    kubernetes_secret.cm_secret_ca
  ]
}

resource "kubectl_manifest" "cm_issuer_platform" {
  yaml_body  = <<-YAML
    apiVersion: cert-manager.io/v1
    kind: Issuer
    metadata:
      name: cm-issuer-platform
      namespace: cert-manager
    spec:
      ca:
        secretName: cm-secret-ca
    YAML
  apply_only = true
  depends_on = [
    helm_release.cert_manager
  ]
}

# kubectl describe clusterissuers
# kubectl describe issuers

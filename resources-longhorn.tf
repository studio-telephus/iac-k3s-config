resource "kubernetes_namespace" "longhorn_system" {
  metadata {
    name = "longhorn-system"
  }
}

# Longhorn storage class for PVs/PVCs for the cluster.
resource "helm_release" "longhorn" {
  name             = "longhorn"
  repository       = "https://charts.longhorn.io"
  chart            = "longhorn"
  version          = "1.5.3"
  namespace        = "longhorn-system"
  create_namespace = "false"
  wait             = "true"
  values = [
    <<-EOT
    enablePSP: false
    persistence:
      defaultClass: true
      defaultFsType: ext4
      defaultClassReplicaCount: 2
      defaultReplicaAutoBalance: least-effort
    defaultSettings:
      kubernetesClusterAutoscalerEnabled: false
      defaultReplicaCount: 2
      replicaAutoBalance: least-effort
      # replicaReplenishmentWaitInterval: 300
      disableSchedulingOnCordonedNode: true
      allowNodeDrainWithLastHealthyReplica: false
      fastReplicaRebuildEnabled: true
      snapshotDataIntegrity: fast-check
      snapshotDataIntegrityCronjob: 0 3 * * *
      snapshotDataIntegrityImmediateCheckAfterSnapshotCreation: false
      upgradeChecker: false
    ingress:
      enabled: true
      ingressClassName: traefik
      host: longhorn.${local.cluster_san}
      tls: true
      secureBackends: false
      tlsSecret: longhorn-tls
      path: /
      annotations:
        nginx.ingress.kubernetes.io/ssl-redirect: "true"
        nginx.ingress.kubernetes.io/force-ssl-redirect: "true"
        cert-manager.io/cluster-issuer: "cm-cluster-issuer"
    EOT
  ]
  depends_on = [kubernetes_namespace.longhorn_system]
}


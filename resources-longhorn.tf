# Longhorn storage class for PVs/PVCs for the cluster.
resource "helm_release" "longhorn" {
  name             = "longhorn"
  repository       = "https://charts.longhorn.io"
  chart            = "longhorn"
  version          = "1.4.1"
  namespace        = "longhorn-system"
  create_namespace = "true"
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
    EOT
  ]
}

resource "time_sleep" "wait_for_longhorn" {
  create_duration = "120s"
  depends_on      = [helm_release.longhorn]
}

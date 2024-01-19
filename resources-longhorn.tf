locals {
  longhorn_config = {
    persistence = {
      defaultClassReplicaCount = {
        dev = 1
        tst = 2
      }
    }
    defaultSettings = {
      defaultReplicaCount = {
        dev = 1
        tst = 2
      }
    }
  }
}

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
      defaultClassReplicaCount: ${local.longhorn_config.persistence.defaultClassReplicaCount[var.env]}
      defaultReplicaAutoBalance: least-effort
    defaultSettings:
      kubernetesClusterAutoscalerEnabled: false
      defaultReplicaCount: ${local.longhorn_config.defaultSettings.defaultReplicaCount[var.env]}
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
  depends_on = [kubernetes_namespace.longhorn_system]
}

resource "time_sleep" "wait_for_longhorn" {
  create_duration = "120s"
  depends_on      = [helm_release.longhorn]
}

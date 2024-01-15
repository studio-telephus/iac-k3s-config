resource "kubernetes_namespace" "iam" {
  metadata {
    name = "iam"
  }
}

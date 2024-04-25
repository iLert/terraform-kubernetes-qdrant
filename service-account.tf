resource "kubernetes_service_account" "this" {
  metadata {
    name      = var.name
    namespace = var.namespace
  }
  automount_service_account_token = true
}

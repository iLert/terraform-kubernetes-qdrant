resource "kubernetes_config_map" "this" {
  metadata {
    name      = var.name
    namespace = var.namespace

    labels = {
      app = var.name
    }
  }

  data = {
    "initialize.sh"   = file("${path.module}/initialize.sh")
    "entrypoint.sh"   = file("${path.module}/entrypoint.sh")
    "production.yaml" = file("${path.module}/production.yaml")
  }
}

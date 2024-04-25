resource "random_password" "qdrant-api-key" {
  length      = 128
  special     = false
  min_lower   = 3
  min_numeric = 3
  min_upper   = 3
}

resource "random_password" "qdrant-read-only-api-key" {
  length      = 128
  special     = false
  min_lower   = 3
  min_numeric = 3
  min_upper   = 3
}

resource "kubernetes_secret" "this" {
  metadata {
    name      = var.name
    namespace = var.namespace
  }

  data = {
    "api-key"           = random_password.qdrant-api-key.result
    "read-only-api-key" = random_password.qdrant-read-only-api-key.result
    "local.yaml"        = <<EOL
service:
  api_key: ${random_password.qdrant-api-key.result}
  read_only_api_key: ${random_password.qdrant-read-only-api-key.result}
    EOL
  }

  type = "Opaque"
}

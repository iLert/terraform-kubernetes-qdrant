resource "kubernetes_service" "this-headless" {
  metadata {
    name      = "${var.name}-headless"
    namespace = var.namespace
  }

  spec {
    selector = {
      app = var.name
    }

    session_affinity            = "ClientIP"
    cluster_ip                  = "None"
    publish_not_ready_addresses = true

    port {
      name        = "http"
      protocol    = "TCP"
      port        = 6333
      target_port = 6333
    }

    port {
      name        = "grpc"
      protocol    = "TCP"
      port        = 6334
      target_port = 6334
    }

    port {
      name        = "p2p"
      protocol    = "TCP"
      port        = 6335
      target_port = 6335
    }

    type = "ClusterIP"
  }
}

resource "kubernetes_service" "this" {
  metadata {
    name      = var.name
    namespace = var.namespace
  }

  spec {
    selector = {
      app = var.name
    }

    session_affinity = "ClientIP"

    port {
      name        = "http"
      protocol    = "TCP"
      port        = 6333
      target_port = 6333
    }

    port {
      name        = "grpc"
      protocol    = "TCP"
      port        = 6334
      target_port = 6334
    }

    port {
      name        = "p2p"
      protocol    = "TCP"
      port        = 6335
      target_port = 6335
    }

    type = "ClusterIP"
  }
}

resource "kubernetes_pod_disruption_budget_v1" "this" {
  metadata {
    name      = var.name
    namespace = var.namespace
  }

  spec {
    max_unavailable = 1
    selector {
      match_labels = {
        app = kubernetes_stateful_set.this.metadata[0].name
      }
    }
  }
}

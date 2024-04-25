resource "kubernetes_stateful_set" "this" {
  metadata {
    name      = var.name
    namespace = var.namespace

    labels = {
      app = var.name
    }
  }

  spec {
    service_name           = kubernetes_service.this-headless.metadata[0].name
    pod_management_policy  = "Parallel"
    replicas               = var.replicas
    revision_history_limit = 10

    update_strategy {
      type = "RollingUpdate"
    }

    selector {
      match_labels = {
        app = var.name
      }
    }

    template {
      metadata {
        labels = {
          app = var.name
        }

        annotations = {
          "prometheus.io/scrape"   = "true"
          "prometheus.io/port"     = "6333"
          "prometheus.io/scheme"   = "http"
          "prometheus.io/path"     = "/metrics"
          "checksum/qdrant-config" = sha256(jsonencode(kubernetes_config_map.this.data))
          "checksum/qdrant-secret" = sha256(jsonencode(kubernetes_secret.this.data))
        }
      }

      spec {
        termination_grace_period_seconds = 30
        service_account_name             = kubernetes_service_account.this.metadata[0].name

        security_context {
          fs_group               = 3000
          fs_group_change_policy = "Always"
        }

        affinity {
          pod_anti_affinity {
            preferred_during_scheduling_ignored_during_execution {
              weight = 100

              pod_affinity_term {
                label_selector {
                  match_expressions {
                    key      = "app"
                    operator = "In"
                    values   = [var.name]
                  }
                }

                topology_key = "topology.kubernetes.io/zone"
              }
            }

            # Spread across nodes
            required_during_scheduling_ignored_during_execution {
              label_selector {
                match_expressions {
                  key      = "app"
                  operator = "In"
                  values   = [var.name]
                }
              }

              topology_key = "kubernetes.io/hostname"
            }
          }
        }

        init_container {
          name              = "busybox"
          image             = "busybox:latest"
          image_pull_policy = "IfNotPresent"
          command = [
            "sh",
            "-c",
            <<EOL
            #!/usr/bin/env bash
            set -x
            ls -lha /qdrant/storage
            chown -R 1000:3000 /qdrant/storage
            EOL
          ]

          volume_mount {
            name       = "qdrant-storage"
            mount_path = "/qdrant/storage"
          }
        }

        container {
          name              = "qdrant"
          image             = "docker.io/qdrant/qdrant:v1.8.4"
          image_pull_policy = "IfNotPresent"
          command           = ["/bin/bash", "-c", "/qdrant/config/initialize.sh"]

          security_context {
            allow_privilege_escalation = false
            privileged                 = false
            read_only_root_filesystem  = true
            run_as_group               = 2000
            run_as_non_root            = true
            run_as_user                = 1000
          }

          env {
            name  = "QDRANT_INIT_FILE_PATH"
            value = "/qdrant/init/.qdrant-initialized"
          }

          # env {
          #   name  = "QDRANT__TELEMETRY_DISABLED"
          #   value = "true"
          # }

          lifecycle {
            pre_stop {
              exec {
                command = [
                  "sh",
                  "-ce",
                  "sleep 3",
                ]
              }
            }
          }

          port {
            name           = "http-metrics"
            container_port = 6333
          }

          port {
            name           = "grpc"
            container_port = 6334
          }

          port {
            name           = "p2p"
            container_port = 6335
          }

          readiness_probe {
            http_get {
              path = "/readyz"
              port = 6333
            }

            initial_delay_seconds = 5
            timeout_seconds       = 1
            period_seconds        = 5
            success_threshold     = 1
            failure_threshold     = 6
          }

          liveness_probe {
            http_get {
              path = "/healthz"
              port = 6333
            }

            initial_delay_seconds = 30
            timeout_seconds       = 5
            period_seconds        = 10
            success_threshold     = 1
            failure_threshold     = 6
          }

          resources {
            limits = {
              memory = var.memory_limit
            }

            requests = {
              cpu    = "10m"
              memory = var.memory_limit
            }
          }

          volume_mount {
            name       = "qdrant-storage"
            mount_path = "/qdrant/storage"
          }

          volume_mount {
            name       = "qdrant-config"
            mount_path = "/qdrant/config/initialize.sh"
            sub_path   = "initialize.sh"
          }

          volume_mount {
            name       = "qdrant-config"
            mount_path = "/qdrant/config/entrypoint.sh"
            sub_path   = "entrypoint.sh"
          }

          volume_mount {
            name       = "qdrant-config"
            mount_path = "/qdrant/config/production.yaml"
            sub_path   = "production.yaml"
          }

          volume_mount {
            name       = "qdrant-secret"
            mount_path = "/qdrant/config/local.yaml"
            sub_path   = "local.yaml"
          }

          volume_mount {
            name       = "qdrant-snapshots"
            mount_path = "/qdrant/snapshots"
          }

          volume_mount {
            name       = "qdrant-init"
            mount_path = "/qdrant/init"
          }
        }

        volume {
          name = "qdrant-config"
          config_map {
            name         = kubernetes_config_map.this.metadata[0].name
            default_mode = "0755"
          }
        }

        volume {
          name = "qdrant-snapshots"
          empty_dir {}
        }

        volume {
          name = "qdrant-init"
          empty_dir {}
        }

        volume {
          name = "qdrant-secret"
          secret {
            secret_name  = kubernetes_secret.this.metadata[0].name
            default_mode = "0600"
          }
        }
      }
    }

    volume_claim_template {
      metadata {
        name = "qdrant-storage"
      }

      spec {
        access_modes       = ["ReadWriteOnce"]
        storage_class_name = ""

        resources {
          requests = {
            storage = var.storage_size
          }
        }
      }
    }
  }
}

variable "namespace" {
  type        = string
  description = "Kubernetes namespace"
  default     = "default"
}

variable "name" {
  type        = string
  description = "Kubernetes resources name"
  default     = "qdrant"
}

variable "replicas" {
  type    = number
  default = 2
}

variable "memory_limit" {
  type    = string
  default = "128Mi"
}

variable "storage_size" {
  type    = string
  default = "10Gi"
}

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
  type        = number
  description = "Replicas count for the Qdrant instances"
  default     = 2
}

variable "memory_limit" {
  type        = string
  description = "Memory limit for the Qdrant instances"
  default     = "128Mi"
}

variable "storage_size" {
  type        = string
  description = "Storage size for the Qdrant instances"
  default     = "10Gi"
}

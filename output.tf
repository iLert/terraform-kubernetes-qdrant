output "service_name" {
  value       = kubernetes_service.this.metadata[0].name
  description = "The name of the Qdrant service in the kubernetes namespace"
}

output "api_key" {
  value       = random_password.qdrant-api-key.result
  description = "The generated api key for the Qdrant API"
}

output "read_only_api_key" {
  value       = random_password.qdrant-read-only-api-key.result
  description = "The generated read only api key for the Qdrant API"
}

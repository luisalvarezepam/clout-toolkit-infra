output "worker_principal_id" {
  description = "Principal ID (Managed Identity) del Worker Container App"
  value       = azurerm_container_app.worker.identity[0].principal_id
}

output "container_app_id" {
  description = "ID completo del recurso Container App Worker"
  value       = azurerm_container_app.worker.id
}

output "container_app_principal_id" {
  description = "Principal ID del Worker Container App"
  value       = azurerm_container_app.worker.identity[0].principal_id
}

output "worker_container_app_id" {
  value = azurerm_container_app.worker.id
}

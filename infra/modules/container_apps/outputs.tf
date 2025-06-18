output "container_app_name" {
  description = "Nombre del Azure Container App"
  value       = azurerm_container_app.backend.name
}

output "container_app_id" {
  description = "ID del Container App"
  value       = azurerm_container_app.backend.id
}

output "container_app_principal_id" {
  description = "Principal ID de la identidad"
  value       = azurerm_container_app.backend.identity[0].principal_id
}

output "container_app_environment_id" {
  description = "ID del Container App Environment"
  value       = azurerm_container_app_environment.env.id
}
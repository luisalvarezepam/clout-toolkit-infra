output "web_app_id" {
  description = "ID del Azure Web App"
  value       = azurerm_linux_web_app.this.id
}

output "web_app_default_hostname" {
  description = "Hostname público del Web App"
  value       = azurerm_linux_web_app.this.default_hostname
}

output "web_app_principal_id" {
  description = "Principal ID de la identidad gestionada del Web App"
  value       = azurerm_linux_web_app.this.identity[0].principal_id
}

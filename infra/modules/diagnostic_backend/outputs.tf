output "diagnostic_setting_id" {
  description = "ID del diagnostic setting creado"
  value       = azurerm_monitor_diagnostic_setting.this.id
}

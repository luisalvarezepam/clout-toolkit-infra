output "db_fqdn" {
  value = azurerm_postgresql_flexible_server.postgres.fqdn
}

output "db_name" {
  value = azurerm_postgresql_flexible_server_database.db.name
}

output "db_admin_username" {
  value = var.admin_username
}


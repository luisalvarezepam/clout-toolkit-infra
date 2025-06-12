output "db_host" {
  description = "FQDN of the PostgreSQL Flexible Server"
  value       = azurerm_postgresql_flexible_server.postgres.fqdn
}

output "postgres_server_name" {
  description = "Name of the PostgreSQL Flexible Server"
  value       = azurerm_postgresql_flexible_server.postgres.name
}

output "db_name" {
  description = "Initial database name"
  value       = azurerm_postgresql_flexible_server_database.db.name
}
output "backend_subnet_id" {
  value = azurerm_subnet.backend.id
}

output "db_subnet_id" {
  value = azurerm_subnet.db.id
}

output "vnet_name" {
  value = azurerm_virtual_network.vnet.name
}

output "private_dns_zone_postgres_id" {
  value = azurerm_private_dns_zone.postgres.id
}

output "subnet_db_id" {
  value = azurerm_subnet.db.id
}

output "subnet_cae_id" {
  value = azurerm_subnet.cae.id
}
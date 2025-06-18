resource "random_password" "postgres_password" {
  length  = 20
  special = true
}

resource "azurerm_postgresql_flexible_server" "postgres" {
  name                   = "psql-${var.name_suffix}"
  location               = var.location
  resource_group_name    = var.resource_group_name
  administrator_login    = var.admin_username
  administrator_password = random_password.postgres_password.result
  version                = "15"

  sku_name   = "B_Standard_B1ms"
 #sku_name   = "Standard_D2s_v3"
  storage_mb = 32768
  zone       = "1"

  public_network_access_enabled = false

  #high_availability {
  #  mode = "ZoneRedundant"
  #}

  authentication {
    active_directory_auth_enabled = false
    password_auth_enabled         = true
  }

  delegated_subnet_id = var.subnet_id
  private_dns_zone_id = azurerm_private_dns_zone.postgres_dns.id

  tags = var.tags
}


resource "azurerm_postgresql_flexible_server_database" "db" {
  name      = var.db_name
  server_id = azurerm_postgresql_flexible_server.postgres.id
  charset   = "UTF8"
  collation = "en_US.utf8"
}

resource "azurerm_key_vault_secret" "db_password" {
  name         = "cloudkit-db-password"
  value        = random_password.postgres_password.result
  key_vault_id = var.key_vault_id

  depends_on = [azurerm_postgresql_flexible_server.postgres]
}

resource "azurerm_private_dns_zone" "postgres_dns" {
  name                = "privatelink.postgres.database.azure.com"
  resource_group_name = var.resource_group_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "postgres_dns_link" {
  name                  = "link-${var.name_suffix}"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.postgres_dns.name
  virtual_network_id    = var.vnet_id
}

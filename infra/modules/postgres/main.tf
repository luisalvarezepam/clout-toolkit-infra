terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.42.0"
    }
    postgresql = {
      source  = "cyrilgdn/postgresql"
      version = ">= 1.18.0"
    }
  }

  required_version = ">= 1.3.0"
}



resource "azurerm_postgresql_flexible_server" "postgres" {
  name                   = "postgres-${local.resource_suffix}"
  location               = var.location
  resource_group_name    = var.rg_name
  administrator_login    = "adminuser"
  administrator_password = data.azurerm_key_vault_secret.pg_admin_password.value
  version                = "13"
  sku_name               = "B1ms"
  storage_mb             = 32768
  zone                   = "1"
  public_network_access_enabled = false
  delegated_subnet_id           = var.postgres_subnet_id
  private_dns_zone_id           = var.private_dns_zone_id

  tags = {
    environment = local.environment
    project     = local.project
  }

  lifecycle {
    ignore_changes = [
      zone
    ]
  }
}


resource "azurerm_postgresql_flexible_server_database" "db" {
  name      = var.db_name
  server_id = azurerm_postgresql_flexible_server.postgres.id
  charset   = "UTF8"
  collation = "en_US.utf8"
}

provider "postgresql" {
  host            = azurerm_postgresql_flexible_server.postgres.fqdn
  port            = 5432
  username        = "adminuser@${azurerm_postgresql_flexible_server.postgres.name}"
  password        = data.azurerm_key_vault_secret.pg_admin_password.value
  sslmode         = "require"
  connect_timeout = 15
}

resource "postgresql_role" "cloudkit_app_user" {
  name     = var.app_user
  login    = true
  password = var.app_password
}

resource "postgresql_grant" "grant_all" {
  database    = var.db_name
  role        = postgresql_role.cloudkit_app_user.name
  object_type = "database"
  privileges  = ["CONNECT", "TEMPORARY"]
}


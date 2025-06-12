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
  name                   = "postgres-cloudkit-dev-east2"
  resource_group_name    = var.rg_name
  location               = var.location
  administrator_login    = var.admin_user
  administrator_password = var.admin_password
  sku_name               = "GP_Standard_D2s_v3"
  version                = "15"
  storage_mb             = 32768
  backup_retention_days  = 7
  zone                   = "1"

  high_availability {
    mode = "ZoneRedundant"
  }

  network {
    delegated_subnet_id = var.db_subnet_id
    private_dns_zone_id = var.private_dns_zone_id
  }

  tags = {
    environment = "dev"
    project     = "cloudkit"
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
  username        = "${var.admin_user}@${azurerm_postgresql_flexible_server.postgres.name}"
  password        = var.admin_password
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

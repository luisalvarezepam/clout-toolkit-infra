resource "azurerm_key_vault" "kv" {
  name                        = "kv-cloudkit-dev-east2"
  location                    = var.location
  resource_group_name         = var.rg_name
  tenant_id                   = var.tenant_id
  sku_name                    = "standard"
  purge_protection_enabled    = true
  soft_delete_retention_days  = 7

  access_policy {
    tenant_id = var.tenant_id
    object_id = var.admin_object_id  # ID del usuario/serv principal que aplicará Terraform

    secret_permissions = [
      "Get", "List", "Set", "Delete", "Purge", "Recover"
    ]
  }

  tags = {
    environment = "dev"
    project     = "cloudkit"
  }
}

resource "azurerm_key_vault_secret" "pg_admin_password" {
  name         = "pg-admin-password"
  value        = var.pg_admin_password
  key_vault_id = azurerm_key_vault.kv.id
}

resource "azurerm_key_vault_secret" "app_user_password" {
  name         = "pg-app-password"
  value        = var.app_password
  key_vault_id = azurerm_key_vault.kv.id
}

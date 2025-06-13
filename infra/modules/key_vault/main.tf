# modules/key_vault/main.tf

resource "azurerm_key_vault" "kv" {
  name                        = "kv-${local.resource_suffix}"
  location                    = var.location
  resource_group_name         = var.rg_name
  tenant_id                   = var.tenant_id
  sku_name                    = "standard"
  purge_protection_enabled    = true
  soft_delete_retention_days  = 7

  access_policy {
    tenant_id = var.tenant_id
    object_id = var.admin_object_id  # Usuario que ejecuta Terraform

    secret_permissions = [
      "Get", "List", "Set", "Delete", "Purge", "Recover"
    ]
  }

  tags = {
    environment = local.environment
    project     = local.project
  }
}

resource "azurerm_user_assigned_identity" "cloudkit_identity" {
  name                = "uami-cloudkit-${local.resource_suffix}"
  location            = var.location
  resource_group_name = var.rg_name
}

data "azurerm_client_config" "current" {}

resource "azurerm_key_vault_access_policy" "identity_policy" {
  key_vault_id = azurerm_key_vault.kv.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azurerm_user_assigned_identity.cloudkit_identity.principal_id

  secret_permissions = [
    "Get", "Set", "List", "Delete"
  ]
}

# Opcional si quieres usar RBAC en lugar de access_policy:
# resource "azurerm_role_assignment" "keyvault_access" {
#   scope                = azurerm_key_vault.kv.id
#   role_definition_name = "Key Vault Secrets Officer"
#   principal_id         = azurerm_user_assigned_identity.cloudkit_identity.principal_id
# }

resource "azurerm_key_vault_secret" "pg_admin_password" {
  name         = "pg-admin-password"
  value        = var.pg_admin_password
  key_vault_id = azurerm_key_vault.kv.id

  depends_on = [
    azurerm_key_vault_access_policy.identity_policy
  ]
}

resource "azurerm_key_vault_secret" "app_user_password" {
  name         = "pg-app-password"
  value        = var.app_password
  key_vault_id = azurerm_key_vault.kv.id

  depends_on = [
    azurerm_key_vault_access_policy.identity_policy
  ]
}


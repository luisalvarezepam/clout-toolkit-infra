resource "azurerm_key_vault" "kv" {
  name                        = "kv-${local.resource_suffix}"
  location                    = var.location
  resource_group_name         = var.rg_name
  tenant_id                   = var.tenant_id
  sku_name                    = "standard"
  purge_protection_enabled    = true
  soft_delete_retention_days  = 7
  enable_rbac_authorization   = true  # ✅ Activar RBAC

  tags = {
    environment = local.environment
    project     = local.project
  }
}

# Identidad administrada (para funciones, etc.)
resource "azurerm_user_assigned_identity" "cloudkit_identity" {
  name                = "uami-cloudkit-${local.resource_suffix}"
  location            = var.location
  resource_group_name = var.rg_name
}

data "azurerm_client_config" "current" {}

# ✅ Permitir a Terraform acceder al Key Vault
resource "azurerm_role_assignment" "terraform_user" {
  scope                = azurerm_key_vault.kv.id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = data.azurerm_client_config.current.object_id
  
  lifecycle {
    ignore_changes = [role_definition_name, scope, principal_id]
  }
}

# ✅ Permitir a la identidad administrada acceder al Key Vault
resource "azurerm_role_assignment" "cloudkit_identity_access" {
  scope                = azurerm_key_vault.kv.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_user_assigned_identity.cloudkit_identity.principal_id
}

# ✅ Secretos
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

resource "azurerm_role_assignment" "tf_kv_rbac" {
  scope = azurerm_key_vault.kv.id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = data.azurerm_client_config.current.object_id
}



resource "azurerm_key_vault" "kv" {
  name                        = "kv-${var.name_suffix}"
  location                    = var.location
  resource_group_name         = var.resource_group_name
  tenant_id                   = var.tenant_id
  sku_name                    = "standard"
  purge_protection_enabled    = true
  soft_delete_retention_days  = 7

  tags = var.tags

  access_policy {
    tenant_id = var.tenant_id
    object_id = var.admin_object_id

    secret_permissions = [
      "Get", "List", "Set", "Delete", "Purge", "Recover"
    ]
  }
    access_policy {
    tenant_id = var.tenant_id
    object_id = "d688206a-39b6-4178-a6b3-8d1d038283bd"

    secret_permissions = [
      "Get", "List", "Set", "Delete", "Purge", "Recover"
    ]
  }

  access_policy {
    tenant_id = var.tenant_id
    object_id = var.app_registration_object_id

    secret_permissions = [
      "Get", "List", "Set"
    ]
  }
}

# Agregar estos recursos al final de main.tf o crear un archivo separado

# Generar una clave secreta para JWT
resource "random_password" "app_secret_key" {
  length  = 64
  special = true
}

# Almacenar el secret key en Key Vault
resource "azurerm_key_vault_secret" "app_secret_key" {
  name         = "app-secret-key"
  value        = random_password.app_secret_key.result
  key_vault_id = module.key_vault.key_vault_id

  depends_on = [module.key_vault]
}

# Secretos para Azure AD (crear estos manualmente o vía variables)
#resource "azurerm_key_vault_secret" "azure_client_id" {
#  name         = "azure-client-id"
#  value        = var.azure_client_id
#  key_vault_id = module.key_vault.key_vault_id

 # depends_on = [module.key_vault]
#}

#resource "azurerm_key_vault_secret" "azure_client_secret" {
#  name         = "azure-client-secret"
#  value        = var.azure_client_secret
#  key_vault_id = module.key_vault.key_vault_id

  #depends_on = [module.key_vault]
#}
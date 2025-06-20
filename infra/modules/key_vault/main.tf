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


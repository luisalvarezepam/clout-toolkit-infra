resource "azurerm_storage_account" "blob" {
  name                     = "st${replace(var.name_suffix, "-", "")}"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  min_tls_version          = "TLS1_2"
  tags                     = var.tags
}

resource "azurerm_storage_container" "inputs" {
  name                  = "cloudkit-inputs"
  storage_account_name  = azurerm_storage_account.blob.name
  container_access_type = "private"
}

resource "azurerm_storage_container" "archive" {
  name                  = "cloudkit-archive"
  storage_account_name  = azurerm_storage_account.blob.name
  container_access_type = "private"
}

data "azurerm_storage_account_blob_container_sas" "sas_inputs" {
  connection_string = azurerm_storage_account.blob.primary_connection_string
  container_name    = azurerm_storage_container.inputs.name
  start             = time_static.sas_start.rfc3339
  expiry            = timeadd(time_static.sas_start.rfc3339, "168h") # 7 días

  permissions {
  read   = true
  add    = false
  create = false
  write  = false
  delete = false
  list   = true
}

}



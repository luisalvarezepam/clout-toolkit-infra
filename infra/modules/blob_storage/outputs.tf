output "storage_account_name" {
  value = azurerm_storage_account.blob.name
}

output "blob_endpoint" {
  value = azurerm_storage_account.blob.primary_blob_endpoint
}

output "inputs_container_name" {
  value = azurerm_storage_container.inputs.name
}

output "archive_container_name" {
  value = azurerm_storage_container.archive.name
}

output "sas_url_inputs" {
  value = "https://${azurerm_storage_account.blob.name}.blob.core.windows.net/${azurerm_storage_container.inputs.name}?${data.azurerm_storage_account_blob_container_sas.sas_inputs.sas}"
}



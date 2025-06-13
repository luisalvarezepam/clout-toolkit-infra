output "key_vault_uri" {
  value = azurerm_key_vault.kv.vault_uri
}
output "key_vault_id" {
  value = azurerm_key_vault.kv.id
}
output "key_vault_name" {
  value = azurerm_key_vault.kv.name
}

output "postgres_admin_password" {
  value = azurerm_key_vault_secret.pg_admin_password.value
}

output "app_user_password" {
  value = azurerm_key_vault_secret.app_user_password.value
}




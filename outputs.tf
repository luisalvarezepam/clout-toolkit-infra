
output "vnet_name" {
  value = module.network.vnet_name
}

output "backend_subnet_id" {
  value = module.network.backend_subnet_id
}

output "db_subnet_id" {
  value = module.network.db_subnet_id
}

output "postgres_server_name" {
  value = module.postgres.postgres_server_name
}

output "postgres_fqdn" {
  value = module.postgres.db_host
}

output "key_vault_name" {
  value = module.key_vault.key_vault_name
}

output "key_vault_uri" {
  value = module.key_vault.key_vault_uri
}

output "container_app_url" {
  value = module.container_apps.backend_url
}

output "static_web_url" {
  value = module.static_web.web_url
}

output "postgres_fqdn" {
  value = module.postgres.db_host
}

output "static_web_url" {
  value = module.static_web.web_url
}
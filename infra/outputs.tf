# Agregar al final de infra/outputs.tf

output "vnet_id" {
  value = module.network.vnet_id
}

output "subnet_ids" {
  value = module.network.subnet_ids
}

output "container_app_principal_id" {
  description = "Object ID de la Managed Identity del Container App"
  value       = module.container_apps.container_app_principal_id
}

output "container_app_id" {
  description = "ID completo del recurso Container App backend"
  value       = module.container_apps.container_app_id
}

output "container_app_url" {
  description = "URL completa del Container App backend"
  value       = module.container_apps.container_app_url
}

output "key_vault_name" {
  description = "Nombre del Key Vault"
  value       = module.key_vault.key_vault_name
}

output "sas_url_inputs" {
  value     = module.blob_storage.sas_url_inputs
  sensitive = true
}

output "worker_principal_id" {
  value = module.container_worker.worker_principal_id
}

output "worker_container_app_id" {
  description = "ID del Worker Container App"
  value       = module.container_worker.container_app_id
}

output "worker_container_app_principal_id" {
  description = "Principal ID del Worker"
  value       = module.container_worker.container_app_principal_id
}

output "web_app_hostname" {
  description = "Hostname público del Web App"
  value       = module.web_app_frontend.web_app_default_hostname
}

output "subnet_prefixes" {
  value = module.network.subnet_prefixes
}
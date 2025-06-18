resource "azurerm_resource_group" "rg" {
  name     = "rg-${local.name_suffix}"
  location = var.location
  tags     = local.tags
}

module "network" {
  source              = "./modules/network"
  name_suffix         = local.name_suffix
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  tags                = local.tags
}

module "key_vault" {
  source                     = "./modules/key_vault"
  name_suffix                = local.name_suffix
  location                   = var.location
  resource_group_name        = azurerm_resource_group.rg.name
  tenant_id                  = var.tenant_id
  admin_object_id            = var.admin_object_id
  app_registration_object_id = var.app_registration_object_id
  tags                       = local.tags
}

module "acr" {
  source              = "./modules/acr"
  name_suffix         = replace(local.name_suffix, "-", "") # ACR no permite guiones
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  tags                = local.tags
}

module "blob_storage" {
  source              = "./modules/blob_storage"
  name_suffix         = local.name_suffix
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  tags                = local.tags
}

module "postgres" {
  source              = "./modules/postgres"
  name_suffix         = local.name_suffix
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = module.network.subnet_ids.db
  vnet_id             = module.network.vnet_id
  key_vault_id        = module.key_vault.key_vault_id
  tags                = local.tags

  # Optional overrides
  # admin_username      = "customadmin"
  # db_name             = "customdb"
}

module "log_analytics" {
  source              = "./modules/log_analytics"
  name_suffix         = local.name_suffix
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  tags                = local.tags
}

module "diagnostic_worker" {
  source                     = "./modules/diagnostic_setting"
  name                       = "diag-worker-${local.name_suffix}"
  target_resource_id         = module.container_worker.worker_container_app_id
  log_analytics_workspace_id = module.log_analytics.workspace_id
}


module "container_worker" {
  source                       = "./modules/container_worker"
  name_suffix                  = local.name_suffix
  location                     = var.location
  resource_group_name          = azurerm_resource_group.rg.name
  #subnet_id                    = module.network.subnet_ids.private
  #acr_login_server             = module.acr.acr_login_server
  image                        = "mcr.microsoft.com/dotnet/samples:aspnetapp"
  use_private_image            = false
  key_vault_uri                = "https://${module.key_vault.key_vault_name}.vault.azure.net/"
  container_app_environment_id = module.container_apps.container_app_environment_id
  tags                         = local.tags
}

resource "azurerm_role_assignment" "acr_pull_worker" {
  scope                = module.acr.acr_id
  role_definition_name = "AcrPull"
  principal_id         = module.container_worker.container_app_principal_id

  depends_on = [module.container_worker]
}

resource "azurerm_key_vault_access_policy" "container_worker_policy" {
  key_vault_id = module.key_vault.key_vault_id
  tenant_id    = var.tenant_id
  object_id    = module.container_worker.container_app_principal_id

  secret_permissions = ["Get", "List"]

  depends_on = [azurerm_role_assignment.acr_pull_worker]
}

module "container_apps" {
  source              = "./modules/container_apps"
  name_suffix         = local.name_suffix
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = module.network.subnet_ids.private
  acr_login_server    = module.acr.acr_login_server
  image               = "mcr.microsoft.com/azuredocs/aci-helloworld:latest"
  #image               = "${module.acr.acr_login_server}/cloudkit-backend:latest"
  use_private_image   = false
  key_vault_uri       = "https://${module.key_vault.key_vault_name}.vault.azure.net/"
  
  tags                = local.tags
}

module "diagnostic_backend" {
  source                     = "./modules/diagnostic_setting"
  name                       = "diag-backend-${local.name_suffix}"
  target_resource_id         = module.container_apps.container_app_id
  log_analytics_workspace_id = module.log_analytics.workspace_id
}

resource "azurerm_key_vault_access_policy" "container_app_policy" {
  #count        = var.create_backend ? 1 : 0
  key_vault_id = module.key_vault.key_vault_id
  tenant_id    = var.tenant_id
  object_id    = module.container_apps.container_app_principal_id

  secret_permissions = ["Get", "List"]
  depends_on = [module.container_apps] # ya no depende de acr_pull

}

module "web_app_frontend" {
  source              = "./modules/web_app_frontend"
  name_suffix         = local.name_suffix
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  image               = "mcr.microsoft.com/dotnet/samples:aspnetapp" # temporal
  use_private_image   = false
  acr_login_server    = module.acr.acr_login_server
  tags                = local.tags
}


resource "azurerm_role_assignment" "acr_pull_webapp" {
  count                = var.use_private_image ? 1 : 0
  scope                = module.acr.acr_id
  role_definition_name = "AcrPull"
  principal_id         = module.web_app_frontend.web_app_principal_id
}


resource "azurerm_key_vault_access_policy" "web_app_policy" {
  key_vault_id = module.key_vault.key_vault_id
  tenant_id    = var.tenant_id
  object_id    = module.web_app_frontend.web_app_principal_id

  secret_permissions = ["Get", "List"]
}

module "network_security" {
  source              = "./modules/network_security"
  name_suffix         = local.name_suffix
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_prefixes     = module.network.subnet_prefixes
  subnet_ids          = module.network.subnet_ids
  tags                = local.tags
}


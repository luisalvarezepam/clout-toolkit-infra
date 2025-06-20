# ========================================
# SECRETS PARA FASTAPI BACKEND
# ========================================

# ========================================
# RANDOM PASSWORDS (antes de los módulos)
# ========================================

# Password para PostgreSQL (usado por el módulo postgres)
resource "random_password" "postgres_password" {
  length  = 20
  special = true
}

# Secreto JWT para FastAPI
resource "random_password" "app_secret_key" {
  length  = 64
  special = true
}

# ========================================
# RESOURCE GROUP
# ========================================

resource "azurerm_resource_group" "rg" {
  name     = "rg-${local.name_suffix}"
  location = var.location
  tags     = local.tags
}

# ========================================
# MÓDULOS (en orden de dependencias)
# ========================================


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

resource "azurerm_key_vault_secret" "db_password" {
  name         = "cloudkit-db-password"
  value        = random_password.postgres_password.result
  key_vault_id = module.key_vault.key_vault_id
}

# Almacenar secretos en Key Vault
resource "azurerm_key_vault_secret" "app_secret_key" {
  name         = "app-secret-key"
  value        = random_password.app_secret_key.result
  key_vault_id = module.key_vault.key_vault_id

  depends_on = [module.key_vault]
}

# Secretos opcionales para Azure AD
resource "azurerm_key_vault_secret" "azure_client_id" {
  count        = var.azure_client_id != "" ? 1 : 0
  name         = "azure-client-id"
  value        = var.azure_client_id
  key_vault_id = module.key_vault.key_vault_id

  depends_on = [module.key_vault]
}

resource "azurerm_key_vault_secret" "azure_client_secret" {
  count        = var.azure_client_secret != "" ? 1 : 0
  name         = "azure-client-secret"
  value        = var.azure_client_secret
  key_vault_id = module.key_vault.key_vault_id

  depends_on = [module.key_vault]
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

# Actualizar la llamada al módulo postgres en main.tf

module "postgres" {
  source              = "./modules/postgres"
  name_suffix         = local.name_suffix
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = module.network.subnet_ids.db
  vnet_id             = module.network.vnet_id
  key_vault_id        = module.key_vault.key_vault_id
  postgres_password   = random_password.postgres_password.result  # Pasar el password directamente
  tags                = local.tags

  depends_on = [
    module.network,
    module.key_vault,
    azurerm_key_vault_secret.db_password
  ]
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

# Reemplazar la sección del módulo container_apps en infra/main.tf

# En infra/main.tf, actualizar la línea del azure_redirect_uri

module "container_apps" {
  source              = "./modules/container_apps"
  name_suffix         = local.name_suffix
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = module.network.subnet_ids.private
  acr_login_server    = module.acr.acr_login_server
  
  # Imagen - usar privada cuando esté lista
  image               = var.use_private_image ? "${module.acr.acr_login_server}/cloudkit-backend:latest" : "mcr.microsoft.com/azuredocs/aci-helloworld:latest"
  use_private_image   = var.use_private_image
  key_vault_uri       = "https://${module.key_vault.key_vault_name}.vault.azure.net/"
  
  # Variables de base de datos - usar directamente los valores
  db_host             = module.postgres.db_fqdn
  db_user             = module.postgres.db_admin_username
  db_name             = module.postgres.db_name
  db_password         = random_password.postgres_password.result
  
  # Variables de aplicación
  app_secret_key      = random_password.app_secret_key.result
  tenant_id           = var.tenant_id
  cors_origins        = "https://${module.web_app_frontend.web_app_default_hostname}"
  # Cambiar esta línea - usar un valor fijo en lugar de referencia circular
  azure_redirect_uri  = "https://backend-${local.name_suffix}.azurecontainerapps.io/auth/azure/callback"
  
  # Variables de Azure AD - usar directamente las variables
  azure_client_id     = var.azure_client_id
  azure_client_secret = var.azure_client_secret
  
  tags                = local.tags
  
  depends_on = [
    module.postgres,
    module.key_vault,
    module.web_app_frontend
  ]
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

# ========================================
# DATA SOURCES PARA LEER SECRETS
# ========================================

data "azurerm_key_vault_secret" "db_password" {
  name         = "cloudkit-db-password"
  key_vault_id = module.key_vault.key_vault_id
  
  depends_on = [module.postgres]
}

data "azurerm_key_vault_secret" "app_secret_key" {
  name         = "app-secret-key"
  key_vault_id = module.key_vault.key_vault_id
  
  depends_on = [azurerm_key_vault_secret.app_secret_key]
}

data "azurerm_key_vault_secret" "azure_client_id" {
  count        = var.azure_client_id != "" ? 1 : 0
  name         = "azure-client-id"
  key_vault_id = module.key_vault.key_vault_id
  
  depends_on = [azurerm_key_vault_secret.azure_client_id]
}

data "azurerm_key_vault_secret" "azure_client_secret" {
  count        = var.azure_client_secret != "" ? 1 : 0
  name         = "azure-client-secret"
  key_vault_id = module.key_vault.key_vault_id
  
  depends_on = [azurerm_key_vault_secret.azure_client_secret]
}
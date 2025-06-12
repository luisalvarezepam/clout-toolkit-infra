
provider "azurerm" {
  features {}
}

module "network" {
  source   = "./modules/network"
  rg_name  = var.rg_name
  location = var.location
}

module "postgres" {
  source              = "./modules/postgres"
  rg_name             = var.rg_name
  location            = var.location
  admin_user          = var.pg_admin_user
  admin_password      = var.pg_admin_password
  db_name             = var.db_name
  app_user            = var.app_user
  app_password        = var.app_password
  db_subnet_id        = module.network.db_subnet_id
  private_dns_zone_id = module.network.private_dns_zone_id
}

module "key_vault" {
  source            = "./modules/key_vault"
  rg_name           = var.rg_name
  location          = var.location
  tenant_id         = var.tenant_id
  admin_object_id   = var.admin_object_id
  pg_admin_password = var.pg_admin_password
  app_password      = var.app_password
}

module "container_apps" {
  source             = "./modules/container_apps"
  rg_name            = var.rg_name
  location           = var.location
  backend_subnet_id  = module.network.backend_subnet_id
  db_host            = module.postgres.db_host
  db_user            = var.app_user
  db_password        = var.app_password
  env_id             = module.network.container_app_env_id
  key_vault_id       = module.key_vault.key_vault_id
  key_vault_uri      = module.key_vault.key_vault_uri
  acr_login_server   = module.container_apps.acr_login_server
  acr_username       = module.container_apps.acr_username
  acr_password       = module.container_apps.acr_password
}

module "static_web" {
  source        = "./modules/static_web"
  rg_name       = var.rg_name
  location      = var.location
  repo_url      = var.repo_url
  branch        = "main"
  custom_domain = var.custom_domain
}

module "acr" {
  source   = "./modules/acr"
  rg_name  = var.rg_name
  location = var.location
}

terraform {
  required_version = ">= 1.3.0"

  backend "azurerm" {
    resource_group_name  = "rg-cloudkit-dev-central"
    storage_account_name = "cloudkitterraforcentr"
    container_name       = "tfstate"
    key                  = "cloudkit-infra.tfstate"
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.91.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "917c94ac-3402-40a8-a538-5f1d44da029a" #
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
  db_name             = var.db_name
  app_user            = var.app_user
  app_password        = var.app_password
  private_dns_zone_id = module.network.private_dns_zone_id
  postgres_subnet_id  = module.network.subnet_db_id
  admin_user          = module.key_vault.postgres_admin_user.value
  admin_password      = module.key_vault.postgres_admin_password.value
  key_vault_name      = module.key_vault.name
  db_subnet_id        = module.network.subnet_db_id
  
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

module "acr" {
  source          = "./modules/acr"
  rg_name         = var.rg_name
  location        = var.location
  resource_suffix = local.resource_suffix
}

module "container_env" {
  source            = "./modules/container_env"
  rg_name           = var.rg_name
  location          = var.location
  backend_subnet_id = module.network.backend_subnet_id
}

module "container_apps" {
  source             = "./modules/container_apps"
  rg_name            = var.rg_name
  location           = var.location
  backend_subnet_id  = module.network.backend_subnet_id
  db_host            = module.postgres.db_host
  db_user            = var.app_user
  db_password        = var.app_password
  env_id             = module.container_env.env_id
  key_vault_id       = module.key_vault.key_vault_id
  key_vault_uri      = module.key_vault.key_vault_uri
  acr_login_server   = module.acr.login_server
  acr_username       = module.acr.admin_username
  acr_password       = module.acr.admin_password
}

module "static_web" {
  source        = "./modules/static_web"
  rg_name       = var.rg_name
  location      = var.location
  repo_url      = var.repo_url
  branch        = "main"
  github_token  = var.github_token
}


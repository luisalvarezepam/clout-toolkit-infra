variable "rg_name" {}
variable "location" {}
variable "backend_subnet_id" {}

# PostgreSQL (se usan como env vars en el contenedor)
variable "db_host" {}
variable "db_user" {}
variable "db_password" { sensitive = true }

# Container App Environment (necesario para la red)
variable "env_id" {}

# Key Vault para referencias
variable "key_vault_id" {}
variable "key_vault_uri" {}

# ACR auth config
variable "acr_login_server" {}
variable "acr_username" {}
variable "acr_password" { description = "Admin password for ACR" }

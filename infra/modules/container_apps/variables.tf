variable "name_suffix" {
  type        = string
  description = "Nombre base para los recursos"
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "key_vault_uri" {
  type = string
}

variable "tags" {
  type        = map(string)
  default     = {}
}

variable "acr_login_server" {
  type        = string
  description = "Login server del ACR (ej. acrname.azurecr.io)"
}

variable "use_private_image" {
  type        = bool
  default     = false
  description = "Indica si se debe usar imagen privada o una imagen pública temporal"
}

variable "image" {
  type = string
}

# Variables para FastAPI
variable "db_host" {
  type        = string
  description = "Hostname de la base de datos PostgreSQL"
}

variable "db_user" {
  type        = string
  description = "Usuario de la base de datos"
  default     = "psqladmin"
}

variable "db_name" {
  type        = string
  description = "Nombre de la base de datos"
  default     = "cloudkitdb"
}

variable "cors_origins" {
  type        = string
  description = "Orígenes permitidos para CORS"
  default     = "https://frontend-cloudkit-dev-cus.azurewebsites.net"
}

variable "tenant_id" {
  type        = string
  description = "Azure Tenant ID"
}

variable "azure_redirect_uri" {
  type        = string
  description = "URI de redirección para Azure AD"
  default     = "https://backend-cloudkit-dev-cus.azurecontainerapps.io/auth/azure/callback"
}

# Variables para secrets (valores sensibles)
variable "db_password" {
  type        = string
  description = "Password de la base de datos"
  sensitive   = true
}

variable "app_secret_key" {
  type        = string
  description = "Clave secreta para JWT"
  sensitive   = true
}

variable "azure_client_id" {
  type        = string
  description = "Azure Client ID para OAuth"
  sensitive   = true
  default     = ""
}

variable "azure_client_secret" {
  type        = string
  description = "Azure Client Secret para OAuth"
  sensitive   = true
  default     = ""
}
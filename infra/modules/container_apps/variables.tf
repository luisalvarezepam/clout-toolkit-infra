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
  type = map(string)
  default = {}
}

variable "create_backend" {
  type        = bool
  description = "Indica si se debe crear el Container App del backend"
  default     = false
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
  type        = string
}
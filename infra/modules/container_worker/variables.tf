variable "name_suffix" {
  type        = string
  description = "Sufijo para nombres de recursos"
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "container_app_environment_id" {
  type        = string
  description = "ID del entorno de Container Apps compartido"
}

variable "image" {
  type        = string
  description = "Ruta completa de la imagen"
  default     = ""
  validation {
    condition     = can(regex("^.+\\.azurecr\\.io/.+:.+$", var.image)) || var.use_private_image == false
    error_message = "La imagen debe tener formato 'acrname.azurecr.io/imagen:tag' si 'use_private_image' es true."
  }
}

variable "key_vault_uri" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "use_private_image" {
  type        = bool
  default     = false
  description = "Indica si usar imagen privada o de prueba"
}


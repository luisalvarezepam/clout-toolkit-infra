variable "name_suffix" {
  description = "Sufijo para los nombres de los recursos"
  type        = string
}

variable "location" {
  description = "Ubicación de los recursos"
  type        = string
}

variable "resource_group_name" {
  description = "Nombre del Resource Group"
  type        = string
}

variable "image" {
  description = "Nombre de la imagen de contenedor (ej. acr.azurecr.io/frontend:latest)"
  type        = string
}

variable "use_private_image" {
  description = "Indica si se usará una imagen privada desde ACR"
  type        = bool
  default     = false
}

variable "acr_login_server" {
  description = "Login server del ACR (requerido si se usa imagen privada)"
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags comunes para los recursos"
  type        = map(string)
  default     = {}
}

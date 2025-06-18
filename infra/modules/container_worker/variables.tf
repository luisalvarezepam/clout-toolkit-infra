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
  description = "Container image to use"
  type        = string

  validation {
    condition     = can(regex("^.+\\/.+:.+$", var.image))
    error_message = "Image must follow the format: registry/image:tag"
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


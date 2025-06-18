variable "name_suffix" {
  type        = string
  description = "Sufijo para nombrar los recursos"
}

variable "location" {
  type        = string
  description = "Ubicación de los recursos"
}

variable "resource_group_name" {
  type        = string
  description = "Nombre del grupo de recursos"
}

variable "tags" {
  type        = map(string)
  default     = {}
}

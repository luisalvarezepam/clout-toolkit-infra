variable "name_suffix" {
  type        = string
  description = "Sufijo para nombrar recursos (ej. cloudkit-dev-cus)"
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "tenant_id" {
  type = string
} 

variable "admin_object_id" {
  type        = string
  description = "Object ID del usuario administrador"
}

variable "app_registration_object_id" {
  type        = string
  description = "Object ID del App Registration usado por Terraform"
}

variable "tags" {
  type    = map(string)
  default = {}
}


variable "name_suffix" {
  type = string
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

variable "admin_username" {
  type = string
  default = "psqladmin"
}

variable "db_name" {
  type = string
  default = "cloudkitdb"
}

variable "key_vault_id" {
  type = string
}

variable "tags" {
  type = map(string)
}

variable "vnet_id" {
  description = "ID de la red virtual donde se conectará la base de datos"
  type        = string
}


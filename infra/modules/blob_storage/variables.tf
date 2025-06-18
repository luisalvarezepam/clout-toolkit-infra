variable "name_suffix" {
  type        = string
  description = "Sufijo estandarizado (ej. cloudkit-dev-cus)"
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}

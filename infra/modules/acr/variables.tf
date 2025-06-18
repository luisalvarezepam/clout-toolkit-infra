variable "name_suffix" {
  type        = string
  description = "Sufijo del nombre, sin guiones (requisito de ACR)"
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

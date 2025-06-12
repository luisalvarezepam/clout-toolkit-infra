variable "rg_name" {}
variable "location" {}
variable "admin_user" {}
variable "admin_password" { sensitive = true }
variable "db_name" {}
variable "app_user" {}
variable "app_password" { sensitive = true }
variable "db_subnet_id" {}
variable "private_dns_zone_id" {}

variable "rg_name" {}
variable "location" {}
variable "tenant_id" {}
variable "admin_object_id" {}

variable "pg_admin_password" { sensitive = true }
variable "app_password" { sensitive = true }

variable "rg_name" {}
variable "location" {}
variable "admin_user" {
  description = "Admin username for PostgreSQL"
  type        = string
}
variable "admin_password" {
  description = "Admin password from Key Vault"
  type        = string
  sensitive   = true
}
variable "db_name" {}
variable "app_user" {}
variable "app_password" { sensitive = true }
variable "db_subnet_id" {}
variable "private_dns_zone_id" {
    type        = string
    description = "ID of the Private DNS Zone for PostgreSQL"
}
variable "postgres_subnet_id" {
  description = "The subnet resource ID for the PostgreSQL Flexible Server."
  type        = string
}
variable "key_vault_name" {
  description = "Name of the Key Vault"
  type        = string
}


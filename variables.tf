
variable "rg_name" {
  default = "rg-cloudkit-dev-east2"
}
variable "location" {
  default = "eastus2"
}
variable "pg_admin_user" {}
variable "pg_admin_password" { sensitive = true }
variable "db_name" {
  default = "cloudkitdb"
}
variable "app_user" {
  default = "cloudkitapp"
}
variable "app_password" { sensitive = true }
variable "tenant_id" {}
variable "admin_object_id" {}
variable "repo_url" {
  default = "https://github.com/luisalvarezepam/KodeKloudEPAM"
}
variable "custom_domain" {
  default = ""
}

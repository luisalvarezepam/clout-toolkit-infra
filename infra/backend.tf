terraform {
  backend "azurerm" {
    resource_group_name  = "rg-cloudkit-dev-central"
    storage_account_name = "cloudkitterraforcentr" # ✅ Debe estar en minúsculas y sin guiones
    container_name       = "tfstate"
    key                  = "cloudkit-infra.tfstate"
  }
}

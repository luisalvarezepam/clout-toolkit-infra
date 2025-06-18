terraform {
  required_version = ">= 1.4.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.98"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_container_registry" "acr" {
  name                = "acr${local.resource_suffix}"
  resource_group_name = var.rg_name
  location            = var.location
  sku                 = "Basic"
  admin_enabled       = true
}
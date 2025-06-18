resource "azurerm_container_registry" "acr" {
  name                = "acr${var.name_suffix}"     # Sin guiones, obligatorio para ACR
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "Basic"
  admin_enabled       = false

  tags = var.tags
}

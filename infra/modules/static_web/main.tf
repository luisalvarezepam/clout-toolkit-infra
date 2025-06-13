resource "azurerm_static_web_app" "frontend" {
  name                = "swa-${local.resource_suffix}"
  resource_group_name = var.rg_name
  location            = var.location
  sku_tier            = "Standard"
  sku_size            = "Standard"

  identity {
    type = "SystemAssigned"
  }

  tags = {
    environment = local.environment
    project     = local.project
  }
}


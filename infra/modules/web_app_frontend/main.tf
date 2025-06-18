# modules/web_app_frontend/main.tf

resource "azurerm_service_plan" "this" {
  name                = "plan-${var.name_suffix}"
  location            = var.location
  resource_group_name = var.resource_group_name
  os_type             = "Linux"
  sku_name            = "B1"

  tags = var.tags
}

resource "azurerm_linux_web_app" "this" {
  name                = "frontend-${var.name_suffix}"
  location            = var.location
  resource_group_name = var.resource_group_name
  service_plan_id     = azurerm_service_plan.this.id

  site_config {
    always_on = true

    application_stack {
      docker_image_name   = var.image
      docker_registry_url = var.use_private_image ? var.acr_login_server : null
    }
  }

  app_settings = {
    WEBSITES_ENABLE_APP_SERVICE_STORAGE = "false"
    DOCKER_REGISTRY_SERVER_URL         = var.use_private_image ? var.acr_login_server : null
  }

  identity {
    type = "SystemAssigned"
  }

  tags = var.tags
}

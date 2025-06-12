resource "azurerm_container_registry" "acr" {
  name                = "acrcloudkitdeveast2"
  resource_group_name = var.rg_name
  location            = var.location
  sku                 = "Basic"
  admin_enabled       = true
}

resource "azurerm_container_app_environment" "env" {
  name                = "cae-cloudkit-dev-east2"
  location            = var.location
  resource_group_name = var.rg_name

  infrastructure_subnet_id = var.backend_subnet_id
  internal_load_balancer_enabled = true

  tags = {
    environment = "dev"
    project     = "cloudkit"
  }
}

resource "azurerm_container_app" "backend" {
  name                         = "ca-backend-cloudkit-dev-east2"
  container_app_environment_id = azurerm_container_app_environment.env.id
  resource_group_name          = var.rg_name
  revision_mode                = "Single"

  template {
    container {
      name   = "cloudkit-api"
      image  = "${azurerm_container_registry.acr.login_server}/cloudkit-api:latest"
      cpu    = 0.5
      memory = "1.0Gi"

      env {
        name  = "DB_HOST"
        value = var.db_host
      }
      env {
        name = "DB_USER"
        value = var.db_user
      }
      env {
        name = "DB_PASSWORD"
        value = var.db_password
      }
    }
  }

  ingress {
    external_enabled = false
    target_port      = 5000
    transport        = "auto"
  }

  registry {
    server   = azurerm_container_registry.acr.login_server
    username = azurerm_container_registry.acr.admin_username
    password = azurerm_container_registry.acr.admin_password
  }

  tags = {
    environment = "dev"
    project     = "cloudkit"
  }
}

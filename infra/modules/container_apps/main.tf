resource "azurerm_container_app_environment" "env" {
  name                             = "env-${var.name_suffix}"
  location                         = var.location
  resource_group_name              = var.resource_group_name
  infrastructure_subnet_id        = var.subnet_id
  internal_load_balancer_enabled  = true
  tags                             = var.tags

}

resource "azurerm_container_app" "backend" {
  name                         = "backend-${var.name_suffix}"
  container_app_environment_id = azurerm_container_app_environment.env.id
  resource_group_name          = var.resource_group_name
  revision_mode                = "Single"

  identity {
    type = "SystemAssigned"
  }

  template {
    container {
      name   = "backend"
      image  = var.image 
      cpu    = 0.5
      memory = "1.0Gi"

      env {
        name  = "ENV"
        value = "dev"
      }

      env {
        name  = "KEY_VAULT_URI"
        value = var.key_vault_uri
      }
    }
  }

  ingress {
  external_enabled = false
  target_port      = 80

  traffic_weight {
    latest_revision = true
    percentage      = 100
  }
}


  tags = var.tags
}




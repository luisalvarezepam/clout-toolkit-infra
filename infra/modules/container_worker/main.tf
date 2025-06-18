resource "azurerm_container_app" "worker" {
  name                         = "worker-${var.name_suffix}"
  container_app_environment_id = var.container_app_environment_id
  resource_group_name          = var.resource_group_name
  revision_mode                = "Single"

  identity {
    type = "SystemAssigned"
  }

  template {
    container {
      name   = "worker"
      image  = var.use_private_image ? var.image : "mcr.microsoft.com/dotnet/samples:aspnetapp"
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
    target_port      = 8080

    traffic_weight {
      latest_revision = true
      percentage      = 100
    }
  }

  tags = var.tags
}
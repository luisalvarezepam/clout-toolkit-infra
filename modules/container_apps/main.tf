resource "azurerm_container_app" "backend" {
  name                         = "ca-backend-cloudkit-dev-east2"
  container_app_environment_id = var.env_id
  resource_group_name          = var.rg_name
  revision_mode                = "Single"

  template {
    container {
      name   = "cloudkit-api"
      image  = "${var.acr_login_server}/cloudkit-api:latest"
      cpu    = 0.5
      memory = "1.0Gi"

      env {
        name  = "DB_HOST"
        value = var.db_host
      }
      env {
        name  = "DB_USER"
        value = var.db_user
      }
      env {
        name  = "DB_PASSWORD"
        value = var.db_password
      }
    }
  }

  ingress {
    target_port = 5000
    transport   = "auto"

    traffic_weight {
      percentage      = 100
      latest_revision = true
    }
  }

  registry {
    server   = var.acr_login_server
    username = var.acr_username
    password = var.acr_password
  }

  tags = {
    environment = "dev"
    project     = "cloudkit"
  }
}

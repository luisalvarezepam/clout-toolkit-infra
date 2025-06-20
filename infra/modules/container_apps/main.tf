resource "azurerm_container_app_environment" "env" {
  name                             = "env-${var.name_suffix}"
  location                         = var.location
  resource_group_name              = var.resource_group_name
  infrastructure_subnet_id         = var.subnet_id
  internal_load_balancer_enabled   = true
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

  # Secrets - crear todos siempre (más simple)
  secret {
    name  = "db-password"
    value = var.db_password
  }

  secret {
    name  = "app-secret-key"
    value = var.app_secret_key
  }

  secret {
    name  = "azure-client-id"
    value = var.azure_client_id != "" ? var.azure_client_id : "not-configured"
  }

  secret {
    name  = "azure-client-secret"
    value = var.azure_client_secret != "" ? var.azure_client_secret : "not-configured"
  }

  template {
    container {
      name   = "backend"
      image  = var.image 
      cpu    = 1.0
      memory = "2.0Gi"

      # Variables de entorno para FastAPI
      env {
        name  = "DB_HOST"
        value = var.db_host
      }

      env {
        name  = "DB_USER"
        value = var.db_user
      }

      env {
        name  = "DB_DB"
        value = var.db_name
      }

      env {
        name        = "DB_PASS"
        secret_name = "db-password"
      }

      env {
        name        = "SECRET_KEY"
        secret_name = "app-secret-key"
      }

      env {
        name  = "ALGORITHM"
        value = "HS256"
      }

      env {
        name  = "ACCESS_TOKEN_EXPIRE_MINUTES"
        value = "30"
      }

      env {
        name  = "CORS_ALLOW_ORIGINS"
        value = var.cors_origins
      }

      # Variables de Azure AD
      env {
        name        = "AZURE_CLIENT_ID"
        secret_name = "azure-client-id"
      }

      env {
        name        = "AZURE_CLIENT_SECRET"
        secret_name = "azure-client-secret"
      }

      env {
        name  = "AZURE_TENANT_ID"
        value = var.tenant_id
      }

      env {
        name  = "AZURE_REDIRECT_URI"
        value = var.azure_redirect_uri
      }

      env {
        name  = "KEY_VAULT_URI"
        value = var.key_vault_uri
      }
    }
  }

  ingress {
    external_enabled = true
    target_port      = 8000

    traffic_weight {
      latest_revision = true
      percentage      = 100
    }
  }

  tags = var.tags
}
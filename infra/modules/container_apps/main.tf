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

  # Secrets obligatorios (siempre tienen valor)
  secret {
    name  = "db-password"
    value = var.db_password
  }

  secret {
    name  = "app-secret-key"
    value = var.app_secret_key
  }

  # Secrets opcionales de Azure AD (solo si tienen valor)
  dynamic "secret" {
    for_each = var.azure_client_id != "" ? toset(["azure-client-id"]) : toset([])
    content {
      name  = secret.value
      value = var.azure_client_id
    }
  }

  dynamic "secret" {
    for_each = var.azure_client_secret != "" ? toset(["azure-client-secret"]) : toset([])
    content {
      name  = secret.value
      value = var.azure_client_secret
    }
  }

  template {
    container {
      name   = "backend"
      image  = var.image 
      cpu    = 1.0      # Aumentado para FastAPI + PostgreSQL
      memory = "2.0Gi"  # Aumentado para FastAPI + PostgreSQL

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

      # Variables de Azure AD (solo si están configuradas)
      dynamic "env" {
        for_each = var.azure_client_id != "" ? toset(["azure-client-id"]) : toset([])
        content {
          name        = "AZURE_CLIENT_ID"
          secret_name = env.value
        }
      }

      dynamic "env" {
        for_each = var.azure_client_secret != "" ? toset(["azure-client-secret"]) : toset([])
        content {
          name        = "AZURE_CLIENT_SECRET"
          secret_name = env.value
        }
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
    external_enabled = true  # Cambiar a true para acceso externo
    target_port      = 8000  # Puerto de FastAPI

    traffic_weight {
      latest_revision = true
      percentage      = 100
    }
  }

  tags = var.tags
}
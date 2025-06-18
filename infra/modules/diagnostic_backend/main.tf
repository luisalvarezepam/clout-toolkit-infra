# modules/diagnostic_backend/main.tf

resource "azurerm_monitor_diagnostic_setting" "this" {
  name                       = var.name
  target_resource_id         = var.target_resource_id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  enabled_log {
    category = "ContainerAppConsoleLogs"
    retention_policy {
      enabled = false
    }
  }

  enabled_log {
    category = "ContainerAppSystemLogs"
    retention_policy {
      enabled = false
    }
  }

  metric {
    category = "AllMetrics"
    enabled  = true
    retention_policy {
      enabled = false
    }
  }
}

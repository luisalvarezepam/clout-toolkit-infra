resource "azurerm_container_app_environment" "env" {
  name                             = "cae-${local.resource_suffix}"
  location                         = var.location
  resource_group_name              = var.rg_name
  infrastructure_subnet_id        = var.backend_subnet_id
  internal_load_balancer_enabled  = true

  tags = {
    environment = "dev"
    project     = "cloudkit"
  }
}

resource "azurerm_static_site" "frontend" {
  name                = "swa-cloudkit-dev-east2"
  location            = var.location
  resource_group_name = var.rg_name

  sku_name            = "Standard"
  repository_url      = var.repo_url
  branch              = var.branch
  build_properties {
    app_location         = "/"
    api_location         = "api"
    output_location      = "dist"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    environment = "dev"
    project     = "cloudkit"
  }
}

resource "azurerm_static_site_custom_domain" "custom" {
  count               = var.custom_domain == "" ? 0 : 1
  static_site_id      = azurerm_static_site.frontend.id
  domain_name         = var.custom_domain
  validation_type     = "dns-txt-token"
}

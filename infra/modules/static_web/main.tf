resource "azurerm_static_site" "frontend" {
  name                = "swa-cloudkit-dev-east2"
  location            = var.location
  resource_group_name = var.rg_name

  identity {
    type = "SystemAssigned"
  }

  tags = {
    environment = "dev"
    project     = "cloudkit"
  }
}

resource "azurerm_static_site_github_action" "github_ci" {
  static_site_id = azurerm_static_site.frontend.id

  repo_url     = var.repo_url
  branch       = var.branch
  github_token = var.github_token

  build_properties {
    app_location    = "/"
    output_location = "dist"
  }
}


resource "azurerm_static_site_custom_domain" "custom" {
  count               = var.custom_domain == "" ? 0 : 1
  static_site_id      = azurerm_static_site.frontend.id
  domain_name         = var.custom_domain
  validation_type     = "dns-txt-token"
}

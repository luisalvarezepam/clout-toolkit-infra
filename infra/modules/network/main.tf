
resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-${local.resource_suffix}"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = var.rg_name
}

resource "azurerm_subnet" "backend" {
  name                 = "snet-backend-${local.resource_suffix}"
  resource_group_name  = var.rg_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/23"]
}



resource "azurerm_nat_gateway" "nat" {
  name                = "nat-${local.resource_suffix}"
  resource_group_name = var.rg_name
  location            = var.location
  sku_name            = "Standard"
}

resource "azurerm_public_ip" "nat_ip" {
  name                = "pip-nat-${local.resource_suffix}"
  location            = var.location
  resource_group_name = var.rg_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_nat_gateway_public_ip_association" "assoc" {
  nat_gateway_id       = azurerm_nat_gateway.nat.id
  public_ip_address_id = azurerm_public_ip.nat_ip.id
}

resource "azurerm_subnet_nat_gateway_association" "backend_nat" {
  subnet_id      = azurerm_subnet.backend.id
  nat_gateway_id = azurerm_nat_gateway.nat.id
}


resource "azurerm_private_dns_zone_virtual_network_link" "postgres_link" {
  name                  = "dns-link-${local.resource_suffix}"
  resource_group_name   = var.rg_name
  private_dns_zone_name = azurerm_private_dns_zone.postgres.name
  virtual_network_id    = azurerm_virtual_network.vnet.id
  registration_enabled  = false
}

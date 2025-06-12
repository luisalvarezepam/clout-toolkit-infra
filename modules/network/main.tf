
resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-cloudkit-dev-east2"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = var.rg_name
}

resource "azurerm_subnet" "backend" {
  name                 = "snet-backend-cloudkit-dev-east2"
  resource_group_name  = var.rg_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.3.0.0/16"]
}

resource "azurerm_subnet" "db" {
  name                 = "snet-db-cloudkit-dev-east2"
  resource_group_name  = var.rg_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.2.0.0/26"]
}

resource "azurerm_nat_gateway" "nat" {
  name                = "nat-cloudkit-dev-east2"
  resource_group_name = var.rg_name
  location            = var.location
  sku_name            = "Standard"
}

resource "azurerm_public_ip" "nat_ip" {
  name                = "pip-nat-cloudkit-dev-east2"
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

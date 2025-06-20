resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-${var.name_suffix}"
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = ["10.0.0.0/16"]  # Corregir de /8 a /16

  tags = var.tags
}

resource "azurerm_subnet" "public" {
  name                 = "subnet-public"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]  # Corregir para estar dentro de 10.0.0.0/16
}

resource "azurerm_subnet" "private" {
  name                 = "subnet-private"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.2.0/24"]  # Corregir para estar dentro de 10.0.0.0/16
}

resource "azurerm_subnet" "db" {
  name                 = "subnet-db"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.3.0/24"]  # Corregir para estar dentro de 10.0.0.0/16
  delegation {
    name = "delegation"

    service_delegation {
      name = "Microsoft.DBforPostgreSQL/flexibleServers"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/action"
      ]
    }
  }
}
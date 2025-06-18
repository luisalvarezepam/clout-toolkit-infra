resource "azurerm_network_security_group" "private" {
  name                = "nsg-private-${var.name_suffix}"
  location            = var.location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "Allow-Internal-Outbound"
    priority                   = 100
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = var.subnet_prefixes.private
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-Public-To-Private"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = var.subnet_prefixes.public
    destination_address_prefix = var.subnet_prefixes.private
  }

  tags = var.tags
}

resource "azurerm_network_security_group" "db" {
  name                = "nsg-db-${var.name_suffix}"
  location            = var.location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "Allow-Private-To-DB"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = var.subnet_prefixes.private
    destination_address_prefix = var.subnet_prefixes.db
  }

  tags = var.tags
}

resource "azurerm_network_security_group" "public" {
  name                = "nsg-public-${var.name_suffix}"
  location            = var.location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "Allow-Internet-Inbound"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "Internet"
    destination_address_prefix = var.subnet_prefixes.public
  }

  tags = var.tags
}

resource "azurerm_subnet_network_security_group_association" "public" {
  subnet_id                 = var.subnet_ids.public
  network_security_group_id = azurerm_network_security_group.public.id
}

resource "azurerm_subnet_network_security_group_association" "private" {
  subnet_id                 = var.subnet_ids.private
  network_security_group_id = azurerm_network_security_group.private.id
}

resource "azurerm_subnet_network_security_group_association" "db" {
  subnet_id                 = var.subnet_ids.db
  network_security_group_id = azurerm_network_security_group.db.id
}

output "vnet_id" {
  value = azurerm_virtual_network.vnet.id
}

output "subnet_ids" {
  value = {
    public  = azurerm_subnet.public.id
    private = azurerm_subnet.private.id
    db      = azurerm_subnet.db.id
  }
}

output "subnet_prefixes" {
  value = {
    public  = azurerm_subnet.public.address_prefixes[0]
    private = azurerm_subnet.private.address_prefixes[0]
    db      = azurerm_subnet.db.address_prefixes[0]
  }
}



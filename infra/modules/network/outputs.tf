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

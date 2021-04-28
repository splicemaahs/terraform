output "subnet_id" {
  value = azurerm_subnet.subnet.id
  sensitive = false
}

output "nsg_id" {
  value = azurerm_network_security_group.nsg.id
  sensitive = false
}

output "nsg_internal_id" {
  value = azurerm_network_security_group.nsg-internal.id
  sensitive = false
}

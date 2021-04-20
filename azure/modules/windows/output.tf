output "windows_jumpbox_name" {
  value = azurerm_windows_virtual_machine.win-vm.name
}

output "windows_jumpbox_ip" {
  value = azurerm_windows_virtual_machine.win-vm.public_ip_address
}
output "windows_jumpbox_private_ip" {
  value = azurerm_windows_virtual_machine.win-vm.private_ip_address
}

output "windows_boxes" {
  value = azurerm_windows_virtual_machine.windows-system
}

output "linux_jumps" {
  value = azurerm_linux_virtual_machine.linux-vm
  sensitive = false
}

output "linux_servers" {
  value = azurerm_linux_virtual_machine.linux-system
  sensitive = false
}

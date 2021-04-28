output "windows_jumps" {
  value = azurerm_windows_virtual_machine.win-vm
  sensitive = false
}
output "windows_boxes" {
  value = azurerm_windows_virtual_machine.windows-system
  sensitive = false
}

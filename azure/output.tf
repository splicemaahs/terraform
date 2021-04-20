output "windows_jumpbox_name" {
  value = module.windows.windows_jumpbox_name
}

output "windows_jumpbox_ip" {
  value = module.windows.windows_jumpbox_ip
}
output "windows_jumpbox_private_ip" {
  value = module.windows.windows_jumpbox_private_ip
}

output "windows_jumpbox_status" {
  value = "az vm get-instance-view --name ${module.windows.windows_jumpbox_name} --resource-group ${var.resource_group} --output table"
}

output "windows_boxes" {
  value = [for lb in module.windows.windows_boxes : map("private_ip", lb.private_ip_address, "vm_name", lb.name, "status_check", "az vm get-instance-view --name ${lb.name} --resource-group ${var.resource_group} --output table")]
}

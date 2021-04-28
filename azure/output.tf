output "windows_jumps" {
  value = [for lb in module.windows.windows_jumps : tomap({"public_ip" = lb.public_ip_address ,"private_ip" = lb.private_ip_address, "vm_name" = lb.name, "status_check" = "az vm get-instance-view --name ${lb.name} --resource-group ${var.resource_group} --output table"})]
  sensitive = false
}

output "windows_boxes" {
  value = [for lb in module.windows.windows_boxes : tomap({"private_ip" = lb.private_ip_address, "vm_name" = lb.name, "status_check" = "az vm get-instance-view --name ${lb.name} --resource-group ${var.resource_group} --output table"})]
  sensitive = false
}

output "linux_jumps" {
  value = [for lb in module.linux.linux_jumps : tomap({"public_ip" = lb.public_ip_address, "private_ip" = lb.private_ip_address, "vm_name" = lb.name, "status_check" = "az vm get-instance-view --name ${lb.name} --resource-group ${var.resource_group} --output table"})]
  sensitive = false
}

output "linux_servers" {
  value = [for lb in module.linux.linux_servers : tomap({"private_ip" = lb.private_ip_address, "vm_name" = lb.name, "status_check" = "az vm get-instance-view --name ${lb.name} --resource-group ${var.resource_group} --output table"})]
  sensitive = false
}

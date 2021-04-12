output "windows_jumpbox_instance_id" {
  value = module.windows.windows_jumpbox_instance_id
}
output "windows_jumpbox_ip" {
    value = module.windows.windows_jumpbox_ip
}
output "windows_jumpbox_private_ip" {
    value = module.windows.windows_jumpbox_private_ip
}
# output "windows_system_instance_id" {
#     value = module.windows.windows_system_instance_id
# }
# output "windows_system_private_ip" {
#     value = module.windows.windows_system_private_ip
# }
output "windows_boxes" {
  value = [for lb in module.windows.windows_boxes : map("private_ip", lb.private_ip, "instance_id", lb.id)]
}

# output "linux_jumpbox_instance_id" {
#   value = module.linux.linux_jumpbox_instance_id
# }
# output "linux_jumpbox_ip" {
#     value = module.linux.linux_jumpbox_ip
# }
# output "linux_jumpbox_private_ip" {
#     value = module.linux.linux_jumpbox_private_ip
# }
# output "linux_boxes" {
#   value = [for lb in module.linux.linux_boxes : map("private_ip", lb.private_ip, "instance_id", lb.id)]
# }

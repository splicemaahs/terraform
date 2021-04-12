output "windows_jumpbox_instance_id" {
  value = aws_instance.windows-jumpbox.id
}
output "windows_jumpbox_ip" {
  value = aws_instance.windows-jumpbox.public_ip
}
output "windows_jumpbox_private_ip" {
  value = aws_instance.windows-jumpbox.private_ip
}

# output "windows_system_instance_id" {
#   value = aws_instance.windows-system.id
# }
# output "windows_system_private_ip" {
# value = aws_instance.windows-system.private_ip
# }

output "windows_boxes" {
  value = aws_instance.windows-system
}

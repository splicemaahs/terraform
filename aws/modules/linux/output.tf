output "linux_jumpbox_instance_id" {
  value = aws_instance.linux-jumpbox.id
}
output "linux_jumpbox_ip" {
  value = aws_instance.linux-jumpbox.public_ip
}
output "linux_jumpbox_private_ip" {
  value = aws_instance.linux-jumpbox.private_ip
}
output "linux_boxes" {
  value = aws_instance.linux-system
}

variable "admin_user" {
    default = "splice"
}
variable "path_to_private_key" { }
variable "path_to_public_key" { }

variable "jumpbox_instance_size" {
    default = "Standard_D4s_v4"
}

variable "instance_size" {
    default = "Standard_D4s_v4"
}

variable "nsg_id" {}
variable "nsg_internal_id" {}
variable "resource_group" {}
variable "subnet_id" {}
variable "location" {}
variable "common_tags" {}
variable "linux_jumpboxes" {
  type        = list(string)
  default = [
    "l-jumpbox1"
  ]
}
variable "linux_machines" {
  type        = list(string)
  default = [
    "l-server1"
  ]
}
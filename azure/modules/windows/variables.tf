variable "admin_user" {
    default = "splice"
}

variable "admin_pass" {
    default = "Passw0rd4U!!!"
}

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
variable "windows_jumpboxes" {
  type        = list(string)
  default = [
    "w-jumpbox1"
  ]
}
variable "windows_machines" {
  type        = list(string)
  default = [
    "w-server1"
    #"w-server2",
    #"w-server3",
    #"w-server4"
  ]
}


variable "admin_user" {
    default = "splice"
}

variable "admin_pass" {
    default = "Passw0rd4U!!!"
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
variable "windows_machines" {
  type        = list(string)
  default = [
    "server1"
    #"server2",
    #"server3",
    #"server4"
  ]
}
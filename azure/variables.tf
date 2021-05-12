variable "client_secret" {
  default = ""
}
variable "client_id" {
  default = ""
}
variable "subscription_id" {
  default = ""
}
variable "tenant_id" {
  default = ""
}

variable "resource_group" {
    default = "sec_poc"
}

variable "path_to_private_key" { default = "winkey" }
variable "path_to_public_key" { default = "winkey.pub" }
variable "admin_user" {
}

variable "admin_pass" {
}

variable "instance_size" {
}

variable "jumpbox_instance_size" {
}

variable "account" {
  default = "nonprod"
}

variable "creator" {
  default = "Splice Machine"
}

variable "location" {
  default = "East US"
}

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
    # ,"l-server2"
    # ,"l-server3"
    # ,"l-server4"
  ]
}

variable "linux_offer" {}
variable "linux_sku" {}
variable "linux_publisher" {}
variable "linux_version" {}

variable "networks_allow" {
  type        = list(string)
  default = [
    "23.20.251.250/32"
    ,"172.21.12.0/22"
  ]
}

# Set to 0 to allow outbound internet traffic from the internal servers
variable "deny_outbound" {
  type = number
  default = 1
}


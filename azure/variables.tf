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

variable "client_secret" {
  default = ""
}

variable "resource_group" {
    default = "sec_poc"
}

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

variable "windows_machines" {
  type        = list(string)
  default = [
    "server1"
    #"server2",
    #"server3",
    #"server4"
  ]
}
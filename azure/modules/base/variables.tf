variable "resource_group" {
    default = "sec_poc"
}

variable "location" {
    default = "East US"
}

variable "common_tags" {}

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

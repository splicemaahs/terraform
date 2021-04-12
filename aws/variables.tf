variable "aws_profile" {}
variable "aws_region" {
  default = "us-east-1"
}
variable "instance_type" {}

variable "path_to_private_key" { default = "winkey" }
variable "path_to_public_key" { default = "winkey.pub" }

variable "account" {
  description = "Account Name.  This sets an AWS tag named 'Department'"
  type        = string
  default     = "nonprod"
}

variable "creator" {
  description = "Value to set AWS TAG 'Creator'"
  type        = string
}

# from network/variables.tf
variable "environment" {
  description = "The name to call the environment."
  type        = string

  validation {
    condition     = length(var.environment) > 4
    error_message = "The environment name needs to be larger than 4 letters."
  }
}

variable "vpc_cidr_block" {
  description = "CIDR block for the EKS VPC"
  type        = string
  default     = "172.21.12.0/22"
}

variable "private_subnet_cidr" {
  description = "Available cidr blocks for private subnets"
  type        = string
  default     = "172.21.12.0/23"
}

variable "is_private" {
  description = "This option removes the IGW and sets up a subnet that can be used to create VPN peering"
  type        = bool
  default     = false
}

# from linux/variables.tf
variable "linux_machines" {
  type        = list(string)
  default = [
    "server1",
    "server2",
    "server3",
    "server4"
  ]
}
variable "windows_machines" {
  type        = list(string)
  default = [
    "server1",
    "server2",
    "server3",
    "server4"
  ]
}

# ----- VARIABLES -----
variable "environment" {
  description = "The name to call the environment."
  type        = string

  validation {
    condition     = length(var.environment) > 4
    error_message = "The environment name needs to be larger than 4 letters."
  }
}

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "172.21.12.0/22"
}

variable "private_subnet_cidr" {
  description = "Available cidr blocks for private subnets"
  type        = string
  default = "172.21.12.0/23"
}

variable "is_private" {
  description = "This option removes the IGW and sets up a subnet that can be used to create VPN peering"
  type        = bool
  default     = false
}

variable "common_tags" {
  description = "A map of key/value for setting AWS TAGs to all resources"
  type        = map(any)
}
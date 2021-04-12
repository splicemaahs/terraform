# VARIABLES
variable "path_to_private_key" { default = "winkey" }
variable "path_to_public_key" { default = "winkey.pub" }
variable "aws_region" {
  default = "us-east-1"
}
variable "instance_type" {}

variable "centos_amis" {
  type = map(any)
  default = {
    us-east-1    = "ami-056b03dba13a2c9dd" # CentOS-8-ec2-8.3.2011.x86_64
    us-west-2    = "ami-0155c31ea13d4abd2" # CentOS-8-ec2-8.3.2011.x86_64
    eu-west-1    = "ami-0a75a5a43b05b4d5f" # CentOS-8-ec2-8.3.2011.x86_64
    eu-central-1 = "ami-0e337c7f9752d9d34" # CentOS-8-ec2-8.3.2011.x86_64
    us-east-2    = "ami-0ac6967966621d983" # CentOS-8-ec2-8.3.2011.x86_64
  }
}

variable "vpc_id" {}
variable "subnet_id" {}

variable "environment" {
  description = "The name to call the environment."
  type        = string

  validation {
    condition     = length(var.environment) > 4
    error_message = "The environment name needs to be larger than 4 letters."
  }
}

variable "common_tags" {
  description = "A map of key/value for setting AWS TAGs to all resources"
  type        = map(any)
}

variable "linux_machines" {
  type        = list(string)
  default = [
    "server1",
    "server2",
    "server3",
    "server4"
  ]
}
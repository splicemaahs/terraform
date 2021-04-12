# VARIABLES
variable "path_to_private_key" { default = "winkey" }
variable "path_to_public_key" { default = "winkey.pub" }
variable "aws_region" {
  default = "us-east-1"
}
variable "instance_type" {}
variable "win_amis" {
  type = map(any)
  default = {
    us-east-1    = "ami-01f0f33ae345884cd" # Windows 10 with Docker for Windows
    us-west-2    = "ami-0afcbc82a6a511e53" # Windows_Server-2016-English-Full-Base-2021.03.10
    eu-west-1    = "ami-0ea60f680298b7e28" # Windows_Server-2016-English-Full-Base-2021.03.10
    eu-central-1 = "ami-07c16fb2c280ce0bf" # Windows_Server-2016-English-Full-Base-2021.03.10
    us-east-2    = "ami-05785493aafc97b8b" # Windows_Server-2016-English-Full-Base-2021.03.10
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

variable "windows_machines" {
  type        = list(string)
  default = [
    "server1",
    "server2",
    "server3",
    "server4"
  ]
}
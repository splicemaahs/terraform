variable "account" {
  description = "Account Name"
  type        = string
  default     = "nonprod"
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-west-1"
}

variable "cloudprovider" {
  type    = string
  default = "aws"
}

variable "creator" {
  description = "Creator"
  type        = string
  default     = "cmaahs@splicemachine.com"
}

variable "environment" {
  description = "Environment Name"
  type        = string
  default     = "cmaahs-eks-dev1"
}

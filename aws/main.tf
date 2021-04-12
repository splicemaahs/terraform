/**
 * # AWS Terraform Module for Splice Machine SEC POC Infrastructure Provisioning
 *
 */
terraform {
  required_version = ">= 0.13.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.24.1"
    }
    time = {
      source  = "hashicorp/time"
      version = "0.6.0"
    }
    vault = {
      source  = "hashicorp/vault"
      version = "2.17.0"
    }
  }
}

provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}

module "tags" {
  source      = "./modules/tags"
  account     = var.account
  creator     = var.creator
  environment = var.environment
}

module "network" {
  source      = "./modules/network"
  environment = var.environment
  common_tags = module.tags.common_tags
  is_private  = var.is_private
}

module "windows" {
  source = "./modules/windows"
  environment = var.environment
  path_to_public_key = var.path_to_public_key
  path_to_private_key = var.path_to_private_key
  aws_region = var.aws_region
  instance_type = var.instance_type
  vpc_id = module.network.vpc_id
  subnet_id = module.network.subnet_id
  common_tags = module.tags.common_tags
  windows_machines = var.windows_machines
}

# module "linux" {
#   source = "./modules/linux"
#   environment = var.environment
#   path_to_public_key = var.path_to_public_key
#   path_to_private_key = var.path_to_private_key
#   aws_region = var.aws_region
#   instance_type = var.instance_type
#   vpc_id = module.network.vpc_id
#   subnet_id = module.network.subnet_id
#   common_tags = module.tags.common_tags
#   linux_machines = var.linux_machines
# }
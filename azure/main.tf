/**
 * # AWS Terraform Module for Splice Machine SEC POC Infrastructure Provisioning
 *
 */
terraform {
  required_version = ">= 0.13.0"
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "2.55.0"
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

provider "azurerm" {
  # Configuration options
  features {}
  subscription_id = "ADD_ME"
  client_id       = "ADD_ME"
  client_secret   = var.client_secret
  tenant_id       = "ADD_ME"
}

module "tags" {
  source      = "./modules/tags"
  account     = var.account
  creator     = var.creator
  resource_group = var.resource_group
}

module "base" {
  source      = "./modules/base"
  resource_group = var.resource_group
  location = var.location
  common_tags = module.tags.common_tags
}

module "windows" {
  source = "./modules/windows"
  admin_user = var.admin_user
  admin_pass = var.admin_pass
  resource_group = var.resource_group
  instance_size = var.instance_size
  subnet_id = module.base.subnet_id
  location = var.location
  nsg_id = module.base.nsg_id
  nsg_internal_id = module.base.nsg_internal_id
  common_tags = module.tags.common_tags
  windows_machines = var.windows_machines
#   vpc_id = module.network.vpc_id
#   subnet_id = module.network.subnet_id
#   common_tags = module.tags.common_tags
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

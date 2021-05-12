/**
 * # AWS Terraform Module for Splice Machine SEC POC Infrastructure Provisioning
 *
 */
terraform {
  required_version = ">= 0.13.0"
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "2.56.0"
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
  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
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
  networks_allow = var.networks_allow
  deny_outbound = var.deny_outbound
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
  windows_jumpboxes = var.windows_jumpboxes
  windows_machines = var.windows_machines
  depends_on = [
    module.base
  ]
#   vpc_id = module.network.vpc_id
#   subnet_id = module.network.subnet_id
#   common_tags = module.tags.common_tags
}

module "linux" {
  source = "./modules/linux"
  admin_user = var.admin_user
  path_to_public_key = var.path_to_public_key
  path_to_private_key = var.path_to_private_key
  resource_group = var.resource_group
  instance_size = var.instance_size
  jumpbox_instance_size = var.jumpbox_instance_size
  subnet_id = module.base.subnet_id
  location = var.location
  nsg_id = module.base.nsg_id
  nsg_internal_id = module.base.nsg_internal_id
  common_tags = module.tags.common_tags
  linux_jumpboxes = var.linux_jumpboxes
  linux_machines = var.linux_machines
  linux_offer = var.linux_offer
  linux_sku = var.linux_sku
  linux_publisher = var.linux_publisher
  linux_version = var.linux_version
  depends_on = [
    module.base
  ]
}
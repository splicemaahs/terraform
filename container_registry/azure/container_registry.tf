terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = ">= 2.26"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "spliceacr"
  location = "westus"
}

resource "azurerm_container_registry" "acr" {
  name                     = "spliceacr"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  sku                      = "Premium"
  admin_enabled            = true
}

output "login_server" {
  value       = azurerm_container_registry.acr.login_server
}
output "admin_username" {
  value       = azurerm_container_registry.acr.admin_username
}
output "admin_password" {
  value       = azurerm_container_registry.acr.admin_password
  description = "The object ID of the user"
}


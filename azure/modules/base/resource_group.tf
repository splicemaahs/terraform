resource "azurerm_resource_group" "resource-group" {
  name     = var.resource_group
  location = var.location
}

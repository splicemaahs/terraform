resource "azurerm_network_security_group" "nsg" {
  name                = "${var.resource_group}-nsg"
  location            = azurerm_resource_group.resource-group.location
  resource_group_name = azurerm_resource_group.resource-group.name
  security_rule = [ {
    access = "Allow"
    description = "RDP"
    destination_address_prefix = "*"
    destination_address_prefixes = [ ]
    destination_application_security_group_ids = [ ]
    destination_port_range = "3389"
    destination_port_ranges = [ ]
    direction = "Inbound"
    name = "RDP"
    priority = 300
    protocol = "TCP"
    source_address_prefix = ""
    source_address_prefixes = ["23.20.251.250/32", "172.21.12.0/22" ]
    source_application_security_group_ids = [ ]
    source_port_range = "*"
    source_port_ranges = [ ]
  } ]
}

resource "azurerm_network_security_group" "nsg-internal" {
  name                = "${var.resource_group}-nsg-internal"
  location            = azurerm_resource_group.resource-group.location
  resource_group_name = azurerm_resource_group.resource-group.name
  security_rule = [ {
    access = "Allow"
    description = "RDP"
    destination_address_prefix = "*"
    destination_address_prefixes = [ ]
    destination_application_security_group_ids = [ ]
    destination_port_range = "3389"
    destination_port_ranges = [ ]
    direction = "Inbound"
    name = "RDP"
    priority = 300
    protocol = "TCP"
    source_address_prefix = ""
    source_address_prefixes = ["172.21.12.0/22" ]
    source_application_security_group_ids = [ ]
    source_port_range = "*"
    source_port_ranges = [ ]
  }, {
    access = "Deny"
    description = "Deny outbound traffic from all VMs to Internet"
    destination_address_prefix = "Internet"
    destination_address_prefixes = [ ]
    destination_application_security_group_ids = [ ]
    destination_port_range = "*"
    destination_port_ranges = [ ]
    direction = "Outbound"
    name = "DenyInternetOutBound"
    priority = 500
    protocol = "*"
    source_address_prefix = "*"
    source_address_prefixes = [ ]
    source_application_security_group_ids = [ ]
    source_port_range = "*"
    source_port_ranges = [ ]
  }
   ]
}

resource "azurerm_network_ddos_protection_plan" "ddos-plan" {
  name                = "${var.resource_group}-ddosplan"
  location            = azurerm_resource_group.resource-group.location
  resource_group_name = azurerm_resource_group.resource-group.name
}

resource "azurerm_subnet" "subnet" {
  name                 = "${var.resource_group}-subnet"
  resource_group_name  = azurerm_resource_group.resource-group.name
  virtual_network_name = azurerm_virtual_network.virtual-network.name
  address_prefixes     = ["172.21.12.0/23"]
}

resource "azurerm_virtual_network" "virtual-network" {
  name                = "${var.resource_group}-vnet"
  location            = azurerm_resource_group.resource-group.location
  resource_group_name = azurerm_resource_group.resource-group.name
  address_space       = ["172.21.12.0/22"]
  # dns_servers         = ["172.21.12.4", "172.21.12.5"]

  ddos_protection_plan {
    id     = azurerm_network_ddos_protection_plan.ddos-plan.id
    enable = true
  }

  # subnet {
  #   name           = "${var.resource_group}-subnet"
  #   address_prefix = "172.21.12.0/23"
  #   # security_group = azurerm_network_security_group.nsg.id
  # }

  tags = merge(
    var.common_tags,
    map(
      "Name", "${var.resource_group}-vnet"
    )
  )
}
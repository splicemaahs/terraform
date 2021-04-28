resource "azurerm_network_interface" "private-nic" {
  for_each = toset(var.windows_machines)
  name                = "${var.resource_group}-${each.value}-nic"
  location            = var.location
  resource_group_name = var.resource_group


  ip_configuration {
    name                          = "${var.resource_group}-${each.value}-internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }

    tags = merge(
    var.common_tags,
    tomap({
      "Name" = "${var.resource_group}-${each.value}-nic"
    })
  )
}

resource "azurerm_network_interface_security_group_association" "private-nic-nsg" {
  for_each = toset(var.windows_machines)
  network_interface_id      = azurerm_network_interface.private-nic[each.value].id
  network_security_group_id = var.nsg_internal_id
}


resource "azurerm_windows_virtual_machine" "windows-system" {
  for_each = toset(var.windows_machines)
  name                = "${var.resource_group}-${each.value}-win10"
  computer_name = each.value
  resource_group_name = var.resource_group
  location            = var.location
  size                = var.instance_size
  admin_username      = var.admin_user
  admin_password      = var.admin_pass
  network_interface_ids = [
    azurerm_network_interface.private-nic[each.value].id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsDesktop"
    offer     = "Windows-10"
    sku       = "20h2-pro"
    version   = "latest"
  }

    tags = merge(
    var.common_tags,
    tomap({
      "Name" = "${var.resource_group}-win10"
    })
  )
}
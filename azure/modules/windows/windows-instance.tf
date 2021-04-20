resource "azurerm_public_ip" "pubip" {
    name                         = "${var.resource_group}-publicip"
    location                     = var.location
    resource_group_name          = var.resource_group
    allocation_method            = "Dynamic"

  tags = merge(
    var.common_tags,
    map(
      "Name", "${var.resource_group}-publicip"
    )
  )
}

resource "azurerm_network_interface" "nic" {
  name                = "${var.resource_group}-jumpbox-nic"
  location            = var.location
  resource_group_name = var.resource_group

  ip_configuration {
    name                          = "${var.resource_group}-internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.pubip.id
  }

    tags = merge(
    var.common_tags,
    map(
      "Name", "${var.resource_group}-jumpbox-nic"
    )
  )
}

resource "azurerm_network_interface_security_group_association" "nic-nsg" {
  network_interface_id      = azurerm_network_interface.nic.id
  network_security_group_id = var.nsg_id
}

resource "azurerm_windows_virtual_machine" "win-vm" {
  name                = "${var.resource_group}-jumpbox-win10"
  computer_name = "jumpbox-win10"
  resource_group_name = var.resource_group
  location            = var.location
  size                = var.instance_size
  admin_username      = var.admin_user
  admin_password      = var.admin_pass
  network_interface_ids = [
    azurerm_network_interface.nic.id,
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
    map(
      "Name", "${var.resource_group}-win10"
    )
  )
}

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
    map(
      "Name", "${var.resource_group}-${each.value}-nic"
    )
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
  computer_name = "${each.value}-win10"
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
    map(
      "Name", "${var.resource_group}-win10"
    )
  )
}
resource "azurerm_network_interface" "private-nic" {
  for_each = toset(var.linux_machines)
  name                = "${var.resource_group}-${each.value}-linux-nic"
  location            = var.location
  resource_group_name = var.resource_group


  ip_configuration {
    name                          = "${var.resource_group}-${each.value}-linux-internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }

    tags = merge(
    var.common_tags,
    tomap({
      "Name" = "${var.resource_group}-${each.value}-linux-nic"
    })
  )
}

resource "azurerm_network_interface_security_group_association" "private-nic-nsg" {
  for_each = toset(var.linux_machines)
  network_interface_id      = azurerm_network_interface.private-nic[each.value].id
  network_security_group_id = var.nsg_internal_id
}


resource "azurerm_linux_virtual_machine" "linux-system" {
  for_each = toset(var.linux_machines)
  name                = "${var.resource_group}-${each.value}-rhel76"
  computer_name = each.value
  resource_group_name = var.resource_group
  location            = var.location
  size                = var.instance_size
  admin_username      = var.admin_user
  network_interface_ids = [
    azurerm_network_interface.private-nic[each.value].id,
  ]
  admin_ssh_key {
    username   = var.admin_user
    public_key = file(var.path_to_public_key)
  }
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
    disk_size_gb = 100
  }

  # source_image_id = "/subscriptions/8777b2db-3764-422b-a302-7aefb352399f/resourceGroups/sec-linux/providers/Microsoft.Compute/images/rhel76-vm-template"

  # source_image_reference {
  #   publisher = "RedHat"
  #   offer     = "RHEL"
  #   sku       = "7lvm-gen2"
  #   version   = "7.6.2020082423"
  # }
  source_image_reference {
    publisher = "OpenLogic"
    offer     = "CentOS"
    sku       = "7_9-gen2"
    version   = "7.9.2021020401"
  }

  tags = merge(
    var.common_tags,
    tomap({
      "Name" = "${var.resource_group}-${each.value}-rhel76"
    })
  )
}

# TODO: why doesn't the [each-value] ref work in the attachment section?
resource "azurerm_managed_disk" "linux-system" {
  for_each = toset(var.linux_machines)
  name                 = "${var.resource_group}-${each.value}-disk1"
  location             = var.location
  resource_group_name  = var.resource_group
  storage_account_type = "Premium_LRS"
  create_option        = "Empty"
  disk_size_gb         = 512
}

resource "azurerm_virtual_machine_data_disk_attachment" "linux-system" {
  for_each = toset(var.linux_machines)
  managed_disk_id    = azurerm_managed_disk.linux-system[each.value].id
  virtual_machine_id = azurerm_linux_virtual_machine.linux-system[each.key].id
  lun                = "10"
  caching            = "ReadWrite"
}
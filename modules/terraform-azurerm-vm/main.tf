
resource "azurerm_public_ip" "this" {
  name                = "pubip"
  location            = var.location
  resource_group_name = var.azurerm_resource_group
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "this" {
  name                = "nic"
  location            = var.location
  resource_group_name = var.azurerm_resource_group

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.this.id
  }
}

resource "azurerm_linux_virtual_machine" "this" {
  name                = "application"
  resource_group_name = var.azurerm_resource_group
  location            = var.location
  size                = "Standard_F2"
  admin_username      = random_string.username.result
  admin_password      = random_password.password.result
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.this.id,
  ]



  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
}

resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "_%@"
}

resource "random_string" "username" {
  length           = 5
  special          = false
}
resource "azurerm_linux_virtual_machine" "vm01" {
  name                = var.vm-name
  resource_group_name = azurerm_resource_group.rg01.name
  location            = azurerm_resource_group.rg01.location
  size                = "Standard_D2als_v7"

  admin_username = var.admin-username
  admin_password = var.admin-password

  # Enable password authentication
  disable_password_authentication = false

  network_interface_ids = [
    azurerm_network_interface.nic01.id
  ]

  os_disk {
    name                 = "linux-os-disk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = 30
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  provisioner "remote-exec" {
  inline = [
    "sudo apt update",
    "sudo apt install nginx -y",
    "git clone https://github.com/AjayKvarma42/terragpro.git",
    "sudo rm /var/www/html/index.nginx-debian.html",
    "sudo mv /home/${var.admin-username}/terragpro/* /var/www/html/"
      ]
  }

   

provisioner "local-exec" {
  command = "echo Public IP: ${self.public_ip_address}"
}

  connection {
    type     = "ssh"
    user     = var.admin-username
    password = var.admin-password
    host     = self.public_ip_address
  }
}

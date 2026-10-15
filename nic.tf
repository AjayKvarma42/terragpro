resource "azurerm_network_interface" "nic01" {
  name                = var.nic-name
  location            = azurerm_resource_group.rg01.location
  resource_group_name = azurerm_resource_group.rg01.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet01.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.pip01.id
  }

  depends_on = [ azurerm_public_ip.pip01 ]
}

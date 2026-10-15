resource "azurerm_virtual_network" "vnet01" {
  name                = var.vnet-name
  address_space       = var.as 
  resource_group_name = azurerm_resource_group.rg01.name
  location = azurerm_resource_group.rg01.location
}

resource "azurerm_subnet" "subnet01" {
  name = var.subnet-name
  virtual_network_name = azurerm_virtual_network.vnet01.name
  resource_group_name = azurerm_resource_group.rg01.name
  address_prefixes = var.ap
}


data "azurerm_resource_group" "rg" {
  name = "trisha-rg"
}

resource "azurerm_subnet" "subnet" {
  name = var.subnet_name
  resource_group_name = data.azurerm_resource_group.rg.name
  virtual_network_name = var.vnet_name
  address_prefixes = var.address_prefixes
}
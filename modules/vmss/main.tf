data "azurerm_resource_group" "rg" {
  name =  var.resource_group_name
}

data "azurerm_subnet" "subnet" {
  name = var.subnet_name
  resource_group_name = data.azurerm_resource_group.rg.name
  virtual_network_name = var.vnet_name
}

data "azurerm_resource_group" "packer-rg" {
  name = var.packer_resource_group_name
}

data "azurerm_lb" "lb" {
  name                = var.lb_name
  resource_group_name = data.azurerm_resource_group.rg.name
}

data "azurerm_lb_backend_address_pool" "bpepool" {
  name            = "BackEndAddressPool"
  loadbalancer_id = data.azurerm_lb.lb.id
}

data "azurerm_image" "image" {
  name                = var.packer_image_name
  resource_group_name = data.azurerm_resource_group.packer-rg.name
}


# Create a new vmss based on the Golden Image

resource "azurerm_windows_virtual_machine_scale_set" "vmss" {
  name                = var.vmss_name
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  admin_username       = "trisha"
  admin_password       = "trisha@1999"
  instances = 2
  computer_name_prefix = "trisha"
  sku = "Standard_F2"
  os_disk {
    caching = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_id = data.azurerm_image.image.id

  network_interface {
    name    = "terraformnetworkprofile"
    primary = true

    ip_configuration {
      name              = "IPConfiguration"
      subnet_id         = data.azurerm_subnet.subnet.id
      load_balancer_backend_address_pool_ids = data.azurerm_lb_backend_address_pool.bpepool.id[*]
      primary = true
    }
  }
}
  
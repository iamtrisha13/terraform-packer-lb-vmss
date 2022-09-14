data "azurerm_resource_group" "rg" {
  name =  "trisha-rg"
}

data "azurerm_subnet" "subnet" {
  name = var.subnet_name
  resource_group_name = data.azurerm_resource_group.rg.name
  virtual_network_name = var.vnet_name
}

resource "random_string" "fqdn" {
 length  = 6
 special = false
 upper   = false
 numeric  = false
}

resource "azurerm_public_ip" "lbip" {
  name                         = "vmss-public-ip"
  location                     = data.azurerm_resource_group.rg.location
  resource_group_name          = data.azurerm_resource_group.rg.name
  allocation_method            = "Static"
  domain_name_label            = random_string.fqdn.result
}

resource "azurerm_lb" "lb" {
  name                = var.lb_name
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.lbip.id
  }
}

resource "azurerm_lb_backend_address_pool" "bpepool" {
  loadbalancer_id     = azurerm_lb.lb.id
  name                = "BackEndAddressPool"
}

resource "azurerm_lb_probe" "lbprobe" {
  loadbalancer_id     = azurerm_lb.lb.id
  name                = "ssh-running-probe"
  port                = var.application_port
}

resource "azurerm_lb_rule" "lbnatrule" {
  loadbalancer_id                = azurerm_lb.lb.id
  name                           = "http"
  protocol                       = "Tcp"
  frontend_port                  = var.application_port
  backend_port                   = var.application_port
  backend_address_pool_ids        = azurerm_lb_backend_address_pool.bpepool.id[*]
  frontend_ip_configuration_name = "PublicIPAddress"
  probe_id                       = azurerm_lb_probe.lbprobe.id
}

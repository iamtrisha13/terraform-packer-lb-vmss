data "azurerm_resource_group" "task-rg" {
  name = "trisha-rg"
}

module "vnet" {
  source                  = "./modules/vnet"
  vnet_name               = "${var.name}-vnet"
  address_space           = var.address_space
  depends_on = [
    data.azurerm_resource_group.task-rg
  ]
}

module "subnet" {
  source              = "./modules/subnet"
  vnet_name           = "${var.name}-vnet"
  address_prefixes    = var.address_prefixes
  subnet_name         = "${var.name}-subnet"
  depends_on = [
    module.vnet
  ]
}

module "nsg" {
  source              = "./modules/nsg"
  nsg_name            = "${var.name}-nsg"
  subnet_name         = "${var.name}-subnet"
  vnet_name           = "${var.name}-vnet"
  depends_on = [
    module.subnet,
    module.vnet
  ]
}

module "vmss" {
  source                  = "./modules/vmss"
  vmss_name                 = "${var.name}-vmss"
  subnet_name         = "${var.name}-subnet"
  vnet_name           = "${var.name}-vnet"
  resource_group_name = "${var.name}-rg"
  packer_resource_group_name = "${var.name}-rg"
  packer_image_name = "${var.name}-PackerImage"
  lb_name = "${var.name}-lb"
  depends_on = [
    module.subnet, module.vnet, module.lb
  ]
}

module "lb" {
  source = "./modules/lb"
  lb_name = "${var.name}-lb"
  application_port = 80
  subnet_name         = "${var.name}-subnet"
  vnet_name           = "${var.name}-vnet"
  depends_on = [
    module.subnet
  ]
}
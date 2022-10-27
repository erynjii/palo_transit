#-----------------------------------------------------------------------------------------------------------------
# Create spoke1 resource group, spoke1 VNET, VNET peering, UDR, internal LB, (2) VMs 

resource "azurerm_resource_group" "spoke1_rg" {
  name     = "rg-${var.spoke1_prefix}"
  location = var.location
}

module "spoke1_vnet" {
  source              = "./modules/vnet/"
  name                = "vnet-${var.spoke1_prefix}"
  resource_group_name = azurerm_resource_group.spoke1_rg.name
  location            = var.location
  vnet_cidr           = var.spoke1_vnet_cidr
  subnet_cidrs        = var.spoke1_subnet_cidrs
  route_table_ids     = [azurerm_route_table.transit.id]

}


resource "azurerm_virtual_network_peering" "spoke1_to_transit" {
  name                         = "vnet-${var.spoke1_prefix}-vnet-${var.transit_prefix}"
  resource_group_name          = azurerm_resource_group.spoke1_rg.name
  virtual_network_name         = module.spoke1_vnet.vnet_name
  remote_virtual_network_id    = module.transit_vnet.vnet_id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true 
}

resource "azurerm_virtual_network_peering" "transit_to_spoke1" {
  name                           = "vnet-${var.transit_prefix}-vnet-${var.spoke1_prefix}"
  resource_group_name            = azurerm_resource_group.transit_rg.name
  virtual_network_name           = module.transit_vnet.vnet_name
  remote_virtual_network_id      = module.spoke1_vnet.vnet_id
    allow_virtual_network_access = true
  allow_forwarded_traffic        = true 
}


resource "azurerm_route" "spoke1_udr" {
  name                   = "udr-${var.spoke1_prefix}"
  resource_group_name    = azurerm_resource_group.transit_rg.name
  route_table_name       = azurerm_route_table.transit.name
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = var.fw_internal_lb_ip
  address_prefix         = var.spoke1_vnet_cidr

}

# data "template_file" "web_startup" {
#   template = file("${path.module}/scripts/web_startup.yml.tpl")
# }

module "spoke1_vm" {
  source              = "./modules/spoke_vm/"
  name                = "vm-${var.spoke1_vm_name}"
  resource_group_name = azurerm_resource_group.spoke1_rg.name
  location            = var.location
  vm_count            = var.spoke1_vm_count
  subnet_id           = module.spoke1_vnet.subnet_ids[0]
  availability_set_id = ""
  backend_pool_id    =  [module.spoke1_lb.backend_pool_id]
  # custom_data         = base64encode(data.template_file.web_startup.rendered)
  publisher           = "MicrosoftWindowsServer"
  offer               = "WindowsServer"
  sku                 = "2019-Datacenter"
  username            = var.spoke_username
  password            = var.spoke_password
  tags                = var.tags

}

module "spoke1_lb" {
  source              = "./modules/lb/"
  name                = "lb-${var.spoke1_prefix}"
  resource_group_name = azurerm_resource_group.spoke1_rg.name
  location            = var.location
  type                = "private"
  sku                 = "Standard"
  probe_ports         = [80]
  frontend_ports      = [80]
  backend_ports       = [80]
  protocol            = "Tcp"
  enable_floating_ip  = false
  subnet_id           = module.spoke1_vnet.subnet_ids[0]
  private_ip_address  = var.spoke1_internal_lb_ip
  network_interface_ids = module.spoke1_vm.nic0_id

  # depends_on = [
  #   module.spoke1_vm
  # ]
}

#-----------------------------------------------------------------------------------------------------------------
# Create spoke2 resource group, VNET, VNET peering, UDR, (1) VM

resource "azurerm_resource_group" "spoke2_rg" {
  name     = "rg-${var.spoke2_prefix}"
  location = var.location
}


module "spoke2_vnet" {
  source              = "./modules/vnet/"
  name                = "vnet-${var.spoke2_prefix}"
  resource_group_name = azurerm_resource_group.spoke2_rg.name
  location            = var.location
  vnet_cidr           = var.spoke2_vnet_cidr
  subnet_cidrs        = var.spoke2_subnet_cidrs
  route_table_ids     = [azurerm_route_table.transit.id]

}

resource "azurerm_virtual_network_peering" "spoke2_to_transit" {
  name                           = "vnet-${var.spoke2_prefix}-vnet-${var.transit_prefix}"
  resource_group_name            = azurerm_resource_group.spoke2_rg.name
  virtual_network_name           = module.spoke2_vnet.vnet_name
  remote_virtual_network_id      = module.transit_vnet.vnet_id
    allow_virtual_network_access = true
  allow_forwarded_traffic        = true 
}

resource "azurerm_virtual_network_peering" "transit_to_spoke2" {
  name                           = "vnet-${var.transit_prefix}-vnet-${var.spoke2_prefix}"
  resource_group_name            = azurerm_resource_group.transit_rg.name
  virtual_network_name           = module.transit_vnet.vnet_name
  remote_virtual_network_id      = module.spoke2_vnet.vnet_id
    allow_virtual_network_access = true
  allow_forwarded_traffic        = true 
}

resource "azurerm_route" "spoke2_udr" {
  name                   = "udr-${var.spoke2_prefix}"
  resource_group_name    = azurerm_resource_group.transit_rg.name
  route_table_name       = azurerm_route_table.transit.name
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = var.fw_internal_lb_ip
  address_prefix         = var.spoke2_vnet_cidr
}

module "spoke2_vm" {
  source              = "./modules/spoke_vm/"
  name                = "vm-${var.spoke2_vm_name}"
  resource_group_name = azurerm_resource_group.spoke2_rg.name
  location            = var.location
  vm_count            = var.spoke2_vm_count
  subnet_id           = module.spoke2_vnet.subnet_ids[0]
  availability_set_id = ""
  publisher           = "MicrosoftWindowsServer"
  offer               = "WindowsServer"
  sku                 = "2019-Datacenter"
  username            = var.spoke_username
  password            = var.spoke_password
  tags                = var.tags
}

# Create spoke3 resource group, VNET, VNET peering, UDR, (1) VM

resource "azurerm_resource_group" "spoke3_rg" {
  name     = "rg-${var.spoke3_prefix}"
  location = var.location
}


module "spoke3_vnet" {
  source              = "./modules/vnet/"
  name                = "vnet-${var.spoke3_prefix}"
  resource_group_name = azurerm_resource_group.spoke3_rg.name
  location            = var.location
  vnet_cidr           = var.spoke3_vnet_cidr
  subnet_cidrs        = var.spoke3_subnet_cidrs
  route_table_ids     = [azurerm_route_table.transit.id]

}

resource "azurerm_virtual_network_peering" "spoke3_to_transit" {
  name                           = "vnet-${var.spoke3_prefix}-vnet-${var.transit_prefix}"
  resource_group_name            = azurerm_resource_group.spoke3_rg.name
  virtual_network_name           = module.spoke3_vnet.vnet_name
  remote_virtual_network_id      = module.transit_vnet.vnet_id
    allow_virtual_network_access = true
  allow_forwarded_traffic        = true 
}

resource "azurerm_virtual_network_peering" "transit_to_spoke3" {
  name                           = "vnet-${var.transit_prefix}-vnet-${var.spoke3_prefix}"
  resource_group_name            = azurerm_resource_group.transit_rg.name
  virtual_network_name           = module.transit_vnet.vnet_name
  remote_virtual_network_id      = module.spoke3_vnet.vnet_id
    allow_virtual_network_access = true
  allow_forwarded_traffic        = true 
}

resource "azurerm_route" "spoke3_udr" {
  name                   = "udr-${var.spoke3_prefix}"
  resource_group_name    = azurerm_resource_group.transit_rg.name
  route_table_name       = azurerm_route_table.transit.name
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = var.fw_internal_lb_ip
  address_prefix         = var.spoke3_vnet_cidr
}

module "spoke3_vm" {
  source              = "./modules/spoke_vm/"
  name                = "vm-${var.spoke3_vm_name}"
  resource_group_name = azurerm_resource_group.spoke3_rg.name
  location            = var.location
  vm_count            = var.spoke3_vm_count
  subnet_id           = module.spoke3_vnet.subnet_ids[0]
  availability_set_id = ""
  publisher           = "MicrosoftWindowsServer"
  offer               = "WindowsServer"
  sku                 = "2019-Datacenter"
  username            = var.spoke_username
  password            = var.spoke_password
  tags                = var.tags
}

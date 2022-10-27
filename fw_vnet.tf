#-----------------------------------------------------------------------------------------------------------------
# Create Transit VNET
resource "azurerm_resource_group" "transit_rg" {
  name     = "rg-${var.global_prefix}${var.transit_prefix}"
  location = var.location
}

module "transit_vnet" {
  source              = "./modules/vnet/"
  name                = "vnet-${var.global_prefix}${var.transit_prefix}"
  vnet_cidr       = var.transit_vnet_cidr
  subnet_names        = var.transit_subnet_names
  subnet_cidrs     = var.transit_subnet_cidrs
  location            = var.location
  resource_group_name = azurerm_resource_group.transit_rg.name
 # route_table_ids   = ["${azurerm_route_table.transit.id}"]
  
}

resource "azurerm_route_table" "transit" {
  name                          = "rt-${var.global_prefix}${var.transit_prefix}"
  location                      = var.location
  resource_group_name           = azurerm_resource_group.transit_rg.name
  disable_bgp_route_propagation = true
}

resource "azurerm_route" "default_udr" {
  name                   = "default-udr"
  resource_group_name    = azurerm_resource_group.transit_rg.name
  route_table_name       = azurerm_route_table.transit.name
  address_prefix         = "0.0.0.0/0"
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = "172.28.2.4"

}
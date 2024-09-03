resource "azurerm_virtual_network" "this" {
  name                = "vnet-launchpad-prd-${local.location_short[var.location]}"
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = local.tags

  address_space = var.vnet_address_space
  # dns_servers   = ["10.0.0.1", "10.0.0.1"]
}


resource "azurerm_subnet" "snet_launchpad_prd" {
  name                 = "snet-launchpad-prd-${local.location_short[var.location]}"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = var.snet_address_prefixes
}

resource "azurerm_network_security_group" "nsg_launchpad_prd" {
  name                = "nsg-launchpad-prd-${local.location_short[var.location]}"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = local.tags
}

resource "azurerm_subnet_network_security_group_association" "snet_launchpad_prd" {
  subnet_id                 = azurerm_subnet.snet_launchpad_prd.id
  network_security_group_id = azurerm_network_security_group.nsg_launchpad_prd.id
}

resource "azurerm_virtual_network" "this" {
  name                = "vnet-launchpad-prd-${local.location_short[var.location]}"
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags

  address_space = var.virtual_network_address_space
  # dns_servers   = ["10.0.0.1", "10.0.0.1"]
}


resource "azurerm_subnet" "this" {
  name                 = "snet-launchpad-prd-${local.location_short[var.location]}"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = var.subnet_address_prefixes
}

resource "azurerm_network_security_group" "this" {
  name                = "nsg-launchpad-prd-${local.location_short[var.location]}"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_subnet_network_security_group_association" "this" {
  subnet_id                 = azurerm_subnet.this.id
  network_security_group_id = azurerm_network_security_group.this.id
}

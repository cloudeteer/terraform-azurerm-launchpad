resource "azurerm_virtual_network" "this" {
  name                = join("-", ["vnet", var.name, "prd", local.location_short[var.location], var.name_suffix])
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags

  address_space = var.virtual_network_address_space
}


resource "azurerm_subnet" "this" {
  name                 = join("-", ["snet", var.name, "prd", local.location_short[var.location], var.name_suffix])
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = var.subnet_address_prefixes
}

resource "azurerm_network_security_group" "this" {
  name                = join("-", ["nsg", var.name, "prd", local.location_short[var.location], var.name_suffix])
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_subnet_network_security_group_association" "this" {
  subnet_id                 = azurerm_subnet.this.id
  network_security_group_id = azurerm_network_security_group.this.id
}

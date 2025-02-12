locals {
  subnet_id = var.subnet_id == null ? azurerm_subnet.this[0].id : var.subnet_id
}

resource "azurerm_virtual_network" "this" {
  count               = var.create_subnet ? 1 : 0
  name                = join("-", compact(["vnet", var.name, "prd", local.location_short[var.location], var.name_suffix]))
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags

  address_space = var.virtual_network_address_space
}

resource "azurerm_subnet" "this" {
  count                = var.create_subnet ? 1 : 0
  name                 = join("-", compact(["snet", var.name, "prd", local.location_short[var.location], var.name_suffix]))
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.this[0].name
  address_prefixes     = var.subnet_address_prefixes
  service_endpoints    = var.service_endpoints
}

resource "azurerm_network_security_group" "this" {
  count               = var.create_subnet ? 1 : 0
  name                = join("-", compact(["nsg", var.name, "prd", local.location_short[var.location], var.name_suffix]))
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_subnet_network_security_group_association" "this" {
  count                     = var.create_subnet ? 1 : 0
  subnet_id                 = local.subnet_id
  network_security_group_id = azurerm_network_security_group.this[0].id
}

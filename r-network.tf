locals {
  current_subnet_id = var.subnet_id != "" ? [var.subnet_id] : [azurerm_subnet.this.id]
}

resource "azurerm_virtual_network" "this" {
  count               = var.subnet_id != "" ? 0 : 1
  name                = join("-", compact(["vnet", var.name, "prd", local.location_short[var.location], var.name_suffix]))
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags

  address_space = var.virtual_network_address_space
}

resource "azurerm_subnet" "this" {
  count                = var.subnet_id != "" ? 0 : 1
  name                 = join("-", compact(["snet", var.name, "prd", local.location_short[var.location], var.name_suffix]))
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = var.subnet_address_prefixes
  service_endpoints    = var.service_endpoints
}

resource "azurerm_network_security_group" "this" {
  name                = join("-", compact(["nsg", var.name, "prd", local.location_short[var.location], var.name_suffix]))
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_subnet_network_security_group_association" "this" {
  for_each = toset(local.current_subnet_id)

  subnet_id                 = each.key
  network_security_group_id = azurerm_network_security_group.this.id
}

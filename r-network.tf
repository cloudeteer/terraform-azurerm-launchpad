locals {
  network_security_group_name = coalesce(
    var.name_overrides.network_security_group,
    join("-", compact(["nsg", var.name, "prd", local.location_short[var.location], var.name_suffix]))
  )

  subnet_id = var.subnet_id == null ? azurerm_subnet.this[0].id : var.subnet_id

  subnet_name = coalesce(
    var.name_overrides.subnet,
    join("-", compact(["snet", var.name, "prd", local.location_short[var.location], var.name_suffix]))
  )

  virtual_network_name = coalesce(
    var.name_overrides.virtual_network,
    join("-", compact(["vnet", var.name, "prd", local.location_short[var.location], var.name_suffix]))
  )
}

resource "azurerm_virtual_network" "this" {
  count               = var.create_subnet ? 1 : 0
  name                = local.virtual_network_name
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags

  address_space = var.virtual_network_address_space
}

resource "azurerm_subnet" "this" {
  count                = var.create_subnet ? 1 : 0
  name                 = local.subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.this[0].name
  address_prefixes     = var.subnet_address_prefixes
  service_endpoints    = var.service_endpoints
}

resource "azurerm_network_security_group" "this" {
  count               = var.create_subnet ? 1 : 0
  name                = local.network_security_group_name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_subnet_network_security_group_association" "this" {
  count                     = var.create_subnet ? 1 : 0
  subnet_id                 = local.subnet_id
  network_security_group_id = azurerm_network_security_group.this[0].id
}

resource "azurerm_resource_group" "example" {
  location = "germanywestcentral"
  name     = "example-resource-group"
}

resource "azurerm_virtual_network" "example" {
  name                = "vnet-example-dev-we-01"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  address_space = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "example" {
  name                = "snet-example-dev-we-01"
  resource_group_name = azurerm_resource_group.example.name

  address_prefixes     = ["10.0.2.0/24"]
  virtual_network_name = azurerm_virtual_network.example.name
}

module "example" {
  source                = "cloudeteer/launchpad/azurerm"
  github_pat            = "justRandomChars"
  vnet_address_space    = azurerm_virtual_network.example.address_space[0]
  snet_address_prefixes = azurerm_subnet.example.address_prefixes[0]
  resource_group_name   = azurerm_resource_group.example.name
  location              = azurerm_resource_group.example.location
  management_groups     = ["mg-cdt"]
}

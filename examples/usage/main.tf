resource "azurerm_resource_group" "example" {
  location = "germanywestcentral"
  name     = "example-resource-group"
}

module "example" {
  source                = "cloudeteer/launchpad/azurerm"
  github_pat = "" #
  vnet_address_space    = ["192.168.0.0/24"]
  snet_address_prefixes = ["192.168.0.0/24"]
  resource_group_name   = azurerm_resource_group.example.name
  location              = azurerm_resource_group.example.location
}

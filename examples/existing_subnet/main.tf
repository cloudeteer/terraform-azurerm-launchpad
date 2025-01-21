variable "my_runner_github_pat" {
  type = string
}
variable "my_runner_github_repo" {
  type = string
}

resource "azurerm_resource_group" "example" {
  location = "germanywestcentral"
  name     = "rg-example-dev-gwc-01"
}

resource "azurerm_virtual_network" "example" {
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.example.location
  name                = "vnet-example-dev-gwc-01"
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_subnet" "example" {
  address_prefixes     = ["10.0.2.0/24"]
  name                 = "subnet-example-dev-gwc-01"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
}

module "example" {
  source = "cloudeteer/launchpad/azurerm"

  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location

  runner_github_pat  = var.my_runner_github_pat
  runner_github_repo = var.my_runner_github_repo

  create_subnet = false
  subnet_id     = azurerm_subnet.example.id

  management_group_names = ["mg-example"]
}

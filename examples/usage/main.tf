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

module "example" {
  source = "cloudeteer/launchpad/azurerm"

  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location

  runner_github_pat  = var.my_runner_github_pat
  runner_github_repo = var.my_runner_github_repo

  virtual_network_address_space = ["10.0.0.0/16"]
  subnet_address_prefixes       = ["10.0.2.0/24"]
  management_group_names        = ["mg-example"]
}

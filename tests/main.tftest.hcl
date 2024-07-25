variables {
  runner_github_pat = "ehifeoifehoiehoce"
  runner_github_repo = "cloudeteer/squad-customer"
  vnet_address_space    = ["192.168.0.0/24"]
  snet_address_prefixes = ["192.168.0.0/24"]
  location              = "germanywestcentral"
  resource_group_name = "rg-lets-launch"
}
provider "azurerm" {
  features {}
}

run "test_input_validation" {
  command = plan

  assert {
    condition = azurerm_virtual_network.vnet_launchpad_prd.address_space[0] == "192.168.0.0/24"
    error_message = "The VNET has an issue"
  }

}

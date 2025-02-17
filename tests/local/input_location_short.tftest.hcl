mock_provider "azurerm" {
  source = "./tests/local/mocks"
}

run "should_succeed_without_location_short" {
  command = plan

  assert {
    // Using the `azurerm_subnet` resource as an example.
    // This may fail if `variables.auto.tfvars` or naming of the subnet is changed.
    condition     = azurerm_subnet.this[0].name == "snet-launchpad-prd-gwc"
    error_message = "Subnet name is not 'snet-launchpad-prd-gwc'."
  }
}

run "should_succeed_with_location_short" {
  command = plan

  variables {
    location_short = {
      germanywestcentral = "switched"
    }
  }

  assert {
    // Using the `azurerm_subnet` resource as an example
    // This may fail naming of the subnet is changed.
    condition     = azurerm_subnet.this[0].name == "snet-launchpad-prd-switched"
    error_message = "Subnet name is not 'snet-launchpad-prd-switched'."
  }
}

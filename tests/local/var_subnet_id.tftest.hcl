variables {
  location                      = "germanywestcentral"
  management_group_names        = ["mg-test-1", "mg-test-2"]
  resource_group_name           = "rg-test-1"
  runner_github_pat             = "github_pat_0000000000000000000000_00000000000000000000000000000000000000000000000000000000000"
  runner_github_repo            = "owner/repo"
  subnet_address_prefixes       = ["192.168.0.0/24"]
  subscription_ids              = ["00000000-0000-0000-0000-000000000000"]
  virtual_network_address_space = ["192.168.0.0/24"]
}

mock_provider "azurerm" {
  source = "./tests/local/mocks"
}

run "should_success_on_subnet_id" {
  variables {
    subnet_address_prefixes       = []
    virtual_network_address_space = []
    subnet_id                     = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/mygroup1/providers/Microsoft.Network/virtualNetworks/myvnet1/subnets/mysubnet1"
  }
  command = plan
}

run "should_fail_on_subnet_id_1" {
  variables {
    virtual_network_address_space = []
    subnet_id                     = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/mygroup1/providers/Microsoft.Network/virtualNetworks/myvnet1/subnets/mysubnet1"
  }
  command         = plan
  expect_failures = [var.subnet_id]
}

run "should_fail_on_subnet_id_2" {
  variables {
    subnet_address_prefixes = []
    subnet_id               = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/mygroup1/providers/Microsoft.Network/virtualNetworks/myvnet1/subnets/mysubnet1"
  }
  command         = plan
  expect_failures = [var.subnet_id]
}

run "should_fail_on_subnet_id_3" {
  variables {
    subnet_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/mygroup1/providers/Microsoft.Network/virtualNetworks/myvnet1/subnets/mysubnet1"
  }
  command         = plan
  expect_failures = [var.subnet_id]
}

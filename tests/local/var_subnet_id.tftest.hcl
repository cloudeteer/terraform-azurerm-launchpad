mock_provider "azurerm" {
  source = "./tests/local/mocks"
}

# Unset variables set as default in variables.auto.tfvars
variables {
  subnet_address_prefixes       = []
  virtual_network_address_space = []
}

run "should_succeed_with_existing_subnet_id" {
  variables {
    create_subnet = false
    subnet_id     = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/mygroup1/providers/Microsoft.Network/virtualNetworks/myvnet1/subnets/mysubnet1"
  }
  command = plan
}

run "should_succeed_creating_subnet" {
  variables {
    create_subnet                 = true
    subnet_address_prefixes       = ["192.168.0.0/24"]
    virtual_network_address_space = ["192.168.0.0/24"]
  }
  command = plan
}

run "should_fail_on_given_subnet_adress_and_subnet_id" {
  variables {
    subnet_address_prefixes = ["192.168.0.0/24"]
    subnet_id               = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/mygroup1/providers/Microsoft.Network/virtualNetworks/myvnet1/subnets/mysubnet1"
  }
  command         = plan
  expect_failures = [var.create_subnet]
}

run "should_fail_on_given_vnet_address_and_subnet_id" {
  variables {
    virtual_network_address_space = ["192.168.0.0/24"]
    subnet_id                     = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/mygroup1/providers/Microsoft.Network/virtualNetworks/myvnet1/subnets/mysubnet1"
  }
  command         = plan
  expect_failures = [var.create_subnet]
}

run "should_fail_on_given_subnet_and_vnet_and_subnet_id" {
  variables {
    subnet_address_prefixes       = ["192.168.0.0/24"]
    virtual_network_address_space = ["192.168.0.0/24"]
    subnet_id                     = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/mygroup1/providers/Microsoft.Network/virtualNetworks/myvnet1/subnets/mysubnet1"
  }
  command         = plan
  expect_failures = [var.create_subnet]
}

run "should_fail_with_no_given_subnet_id_or_creation" {
  variables {
    create_subnet = false
  }
  command         = plan
  expect_failures = [var.create_subnet]
}

run "should_fail_with_given_subnet_id_and_create_subnet" {
  variables {
    create_subnet = true
    subnet_id     = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/mygroup1/providers/Microsoft.Network/virtualNetworks/myvnet1/subnets/mysubnet1"
  }
  command         = plan
  expect_failures = [var.create_subnet]
}

run "should_fail_with_given_subnet_and_created_nsg" {
  variables {
    create_subnet = false
    subnet_id     = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/mygroup1/providers/Microsoft.Network/virtualNetworks/myvnet1/subnets/mysubnet1"
  }
  command = plan
  assert {
    condition     = length(azurerm_network_security_group.this) == 0
    error_message = "No Network Security Group (NSG) should be created if you bring your own Subnet."
  }
}

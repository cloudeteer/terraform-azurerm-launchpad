mock_provider "azurerm" {
  source = "./tests/local/mocks"
}

variables {
  subnet_address_prefixes       = ["192.168.0.0/24"]
  virtual_network_address_space = ["192.168.0.0/24"]
}

run "should_fail_when_rbac_is_disabled_but_subscription_ids_are_set" {
  command = plan

  variables {
    create_role_assignments = false
    subscription_ids        = ["00000000-0000-0000-0000-000000000000"]
  }

  expect_failures = [var.create_role_assignments]
}

run "should_fail_when_rbac_is_disabled_but_management_group_names_are_set" {
  command = plan

  variables {
    create_role_assignments = false
    management_group_names  = ["mg-tftest"]
  }

  expect_failures = [var.create_role_assignments]
}

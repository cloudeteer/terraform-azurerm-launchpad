mock_provider "azurerm" {
  source = "./tests/local/mocks"
}

run "should_succeed_with_default_role_definition_name" {
  command = plan
}

run "should_succeed_with_role_definition_name_owner" {
  command = plan

  variables {
    role_definition_name = "Owner"
  }
}

run "should_succeed_with_role_definition_name_contributor" {
  command = plan

  variables {
    role_definition_name = "Contributor"
  }
}

run "should_fail_with_unknown_role_definition" {
  command = plan

  variables {
    role_definition_name = "UnknownValue"
  }

  expect_failures = [var.role_definition_name]
}

variables {
  subnet_address_prefixes       = ["192.168.0.0/24"]
  virtual_network_address_space = ["192.168.0.0/24"]
}

mock_provider "azurerm" {
  source = "./tests/local/mocks"
}

run "should_fail_with_wrong_runner_github_repo_format" {
  variables {
    runner_github_repo = "cloudeteer-squadTerraform"
  }
  command         = plan
  expect_failures = [var.runner_github_repo]
}

run "should_fail_with_wrong_runner_github_repo_format_2" {
  variables {
    runner_github_repo = "cloudeteer/squadTerraform/customer"
  }
  command         = plan
  expect_failures = [var.runner_github_repo]
}

run "should_pass_on_init_true" {
  command = plan
  variables {
    init                                           = true
    key_vault_public_network_access_enabled        = true
    key_vault_public_network_access_ip_rules       = ["127.0.0.1"]
    storage_account_public_network_access_enabled  = true
    storage_account_public_network_access_ip_rules = ["127.0.0.1"]
  }
}

run "should_fail_on_undefined_runner_arch" {
  command = plan
  variables {
    runner_arch = "arm86"
  }
  expect_failures = [var.runner_arch]
}

run "should_fail_on_invalid_subscription_ids_format" {
  command = plan
  variables {
    subscription_ids = ["00000000-0000-0000-0000-000000000000", "00000000000000000000000000000000"]
  }
  expect_failures = [var.subscription_ids]
}

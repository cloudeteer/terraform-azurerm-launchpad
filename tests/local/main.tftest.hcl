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

run "should_fail_on_missing_init_access_ip_address" {
  command = plan
  variables {
    init = true
  }
  expect_failures = [var.init_access_ip_address]
}

run "should_pass_on_init_true" {
  command = plan
  variables {
    init                   = true
    init_access_ip_address = "127.0.0.1"
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

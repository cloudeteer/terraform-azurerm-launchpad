variables {
  location              = "germanywestcentral"
  management_groups     = ["mg-test-1", "mg-test-2"]
  resource_group_name   = "rg-test-1"
  runner_github_pat     = "github_pat_0000000000000000000000_00000000000000000000000000000000000000000000000000000000000"
  runner_github_repo    = "owner/repo"
  snet_address_prefixes = ["192.168.0.0/24"]
  subscription_ids      = ["00000000-0000-0000-0000-000000000000"]
  vnet_address_space    = ["192.168.0.0/24"]
}

mock_provider "azurerm" {
  source = "./tests/local/mock_provider"
}

run "use_wrong_format_repo_1" {
  variables {
    runner_github_repo = "cloudeteer-squadTerraform"
  }
  command         = plan
  expect_failures = [var.runner_github_repo]
}

run "use_wrong_format_repo_2" {
  variables {
    runner_github_repo = "cloudeteer/squadTerraform/customer"
  }
  command         = plan
  expect_failures = [var.runner_github_repo]
}

run "test_input_init_fail" {
  command = plan
  variables {
    init = true
  }
  expect_failures = [var.init_access_ip_address]
}

run "test_input_init" {
  command = plan
  variables {
    init                   = true
    init_access_ip_address = "127.0.0.1"
  }
}

run "use_undefined_arch" {
  command = plan
  variables {
    runner_arch = "arm86"
  }
  expect_failures = [var.runner_arch]
}

run "use_wrong_format_for_sub_id" {
  command = plan
  variables {
    subscription_ids = ["00000000-0000-0000-0000-000000000000", "00000000000000000000000000000000"]
  }
  expect_failures = [var.subscription_ids]
}

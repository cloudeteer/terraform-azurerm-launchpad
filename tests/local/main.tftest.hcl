variables {
  runner_github_pat     = "ehifeoifehoiehoce"
  runner_github_repo    = "cloudeteer/squad-customer"
  vnet_address_space    = ["192.168.0.0/24"]
  snet_address_prefixes = ["192.168.0.0/24"]
  location              = "germanywestcentral"
  resource_group_name   = "rg-lets-launch"
  management_groups     = ["cdt-mgmt"]
  subscription_ids      = ["12345678-1234-9876-4563-123456789012"]
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
    subscription_ids = ["12345678-1234-9876-4563-123456789012", "12345678-1234-9876-4563-12345678901"]
  }
  expect_failures = [var.subscription_ids]
}

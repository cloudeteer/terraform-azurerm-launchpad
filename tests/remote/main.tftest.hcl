provider "azurerm" {
  # mandatory, because we use `default_to_oauth_authentication = true` on the storage account
  storage_use_azuread = true

  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

run "setup_tests" {
  command = apply

  variables {
    location            = "West Europe"
    resource_group_name = "rg-tftest-dev-we-01"
  }

  module {
    source = "./tests/remote"
  }
}

run "deploy_module" {
  command = apply

  variables {
    resource_group_name = run.setup_tests.resource_group_name
    location            = run.setup_tests.resource_group_location
    management_groups   = []
    snet_address_prefixes = ["10.0.0.0/28"]
    vnet_address_space    = ["10.0.0.0/27"]

    # Do not create VM instance
    runner_vm_instances = 0
    runner_github_pat   = ""
    runner_github_repo  = "cloudeteer/terraform-azurerm-launchpad"

    # Initial deployment
    init = true
    init_access_ip_address = run.setup_tests.init_access_ip_address
  }
}
# This override file is mandatory for Terraform tests.
# Not needed to use this example.

terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
    random = {
      source = "hashicorp/random"
    }
  }
}

module "example" {
  source                = "../.."
  my_runner_github_pat  = "github_pat_0000000000000000000000_00000000000000000000000000000000000000000000000000000000000"
  my_runner_github_repo = "owner/repository"
}

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
  source = "../.."
}

variable "my_runner_github_pat" {
  type    = string
  default = "github_pat_0000000000000000000000_00000000000000000000000000000000000000000000000000000000000"
}
variable "my_runner_github_repo" {
  type    = string
  default = "owner/repository"
}

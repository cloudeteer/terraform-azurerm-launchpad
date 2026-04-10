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

variable "my_runner_token" {
  type    = string
  default = "AAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
}
variable "my_runner_github_repo" {
  type    = string
  default = "owner/repository"
}

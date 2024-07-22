terraform {
  required_version = "~> 1.8"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.111.0"
    }
  }
}

provider "random" {
  version = "~> 3.6.0"
}

provider "azuread" {
  version = "~> 2.53"
}

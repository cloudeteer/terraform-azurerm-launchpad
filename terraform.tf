terraform {
  required_version = ">= 1.9"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.114"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.6"
    }
  }
}

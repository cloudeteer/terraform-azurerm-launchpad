terraform {
  required_version = "1.9.6"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.114"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.6"
    }
    http = {
      source  = "hashicorp/http"
      version = "3.4"
    }
  }
}

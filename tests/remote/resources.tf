terraform {
  required_version = "~> 1.9"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.114"
    }
    http = {
      source  = "hashicorp/http"
      version = "~> 3.4"
    }
  }
}

resource "azurerm_resource_group" "tftest" {
  name     = var.resource_group_name
  location = var.location
}

output "resource_group_name" {
  value = azurerm_resource_group.tftest.name
}

output "resource_group_location" {
  value = azurerm_resource_group.tftest.location
}

data "http" "init_access_ip_address" {
  url = "https://ipv4.icanhazip.com"
}

output "init_access_ip_address" {
  value = trimspace(data.http.init_access_ip_address.response_body)
}

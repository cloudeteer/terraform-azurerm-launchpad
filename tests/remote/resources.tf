variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

resource "random_string" "resource_group_suffix" {
  length  = 4
  special = false
  upper   = false
}

resource "azurerm_resource_group" "tftest" {
  name     = "${var.resource_group_name}-${random_string.resource_group_suffix.result}"
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

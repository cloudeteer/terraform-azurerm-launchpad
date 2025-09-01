variable "location" {
  type        = string
  description = "The geographic location where the resources will be deployed. This is must be a region name supported by Azure."
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group in which the virtual machine should exist. Changing this forces a new resource to be created."
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
  value       = azurerm_resource_group.tftest.name
  description = "The name of the resource group in which the virtual machine should exist. Changing this forces a new resource to be created."
}

output "resource_group_location" {
  value       = azurerm_resource_group.tftest.location
  description = "The geographic location where the resources will be deployed. This is must be a region name supported by Azure."
}

data "http" "init_access_ip_address" {
  url = "https://ipv4.icanhazip.com"
}

output "init_access_ip_address" {
  value       = trimspace(data.http.init_access_ip_address.response_body)
  description = "The IP Address of your current public IP in order to access the new created resources. For more information please go here https://github.com/cloudeteer/terraform-azurerm-launchpad/blob/main/INSTALL.md "
}

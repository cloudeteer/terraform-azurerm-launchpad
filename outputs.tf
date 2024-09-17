output "LAUNCHPAD_AZURE_CLIENT_ID" {
  value       = azurerm_user_assigned_identity.this.client_id
  description = "The Client ID of the Azure User Assigned Identity for the Launchpad."
}

output "LAUNCHPAD_AZURE_TENANT_ID" {
  value       = azurerm_user_assigned_identity.this.tenant_id
  description = "The Tenant ID associated with the Azure User Assigned Identity for the Launchpad."
}

output "LAUNCHPAD_AZURE_STORAGE_ACCOUNT_NAME" {
  value       = azurerm_storage_account.this.name
  description = "The name of the Azure Storage Account created for the Launchpad."
}

output "location" {
  value       = var.location
  description = "The Azure region where the resources for the Launchpad are deployed."
}

output "vnet_name" {
  value       = azurerm_virtual_network.this.name
  description = "The name of the Azure Virtual Network (VNet) associated with the Launchpad."
}

output "vnet_id" {
  value       = azurerm_virtual_network.this.id
  description = "The ID of the Azure Virtual Network (VNet) associated with the Launchpad."
}

output "subnet_name" {
  value       = azurerm_subnet.snet_launchpad_prd.name
  description = "The name of the subnet within the Virtual Network, associated with the Launchpad production environment."
}

output "subnet_id" {
  value       = azurerm_subnet.snet_launchpad_prd.id
  description = "The ID of the subnet within the Virtual Network, associated with the Launchpad production environment."
}

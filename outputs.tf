output "LAUNCHPAD_AZURE_CLIENT_ID" {
  value       = azurerm_user_assigned_identity.this.client_id
  description = "The client ID of the Azure user identity assigned to the Launchpad."
}

output "LAUNCHPAD_AZURE_STORAGE_ACCOUNT_NAME" {
  value       = azurerm_storage_account.this.name
  description = "The storage account name used by the Launchpad for the Terraform state backend."
}

output "LAUNCHPAD_AZURE_TENANT_ID" {
  value       = azurerm_user_assigned_identity.this.tenant_id
  description = "The tenant ID of the Azure user identity assigned to the Launchpad"
}

output "subnet_id" {
  value       = azurerm_subnet.this.id
  description = "The ID of the subnet within the Virtual Network, associated with the Launchpad production environment."
}

output "subnet_name" {
  value       = azurerm_subnet.this.name
  description = "The name of the subnet within the Virtual Network, associated with the Launchpad production environment."
}

output "virtual_network_id" {
  value       = azurerm_virtual_network.this.id
  description = "The ID of the Azure Virtual Network (VNet) associated with the Launchpad."
}

output "virtual_network_name" {
  value       = azurerm_virtual_network.this.name
  description = "The name of the Azure Virtual Network (VNet) associated with the Launchpad."
}

# tflint-ignore: terraform_naming_convention
output "LAUNCHPAD_AZURE_CLIENT_ID" {
  value       = azurerm_user_assigned_identity.this.client_id
  description = "The client ID of the Azure user identity assigned to the Launchpad."
}

# tflint-ignore: terraform_naming_convention
output "LAUNCHPAD_AZURE_STORAGE_ACCOUNT_NAME" {
  value       = azurerm_storage_account.this.name
  description = "The storage account name used by the Launchpad for the Terraform state backend."
}

# tflint-ignore: terraform_naming_convention
output "LAUNCHPAD_AZURE_TENANT_ID" {
  value       = azurerm_user_assigned_identity.this.tenant_id
  description = "The tenant ID of the Azure user identity assigned to the Launchpad"
}

output "key_vault_private_endpoint_private_ip_address" {
  value       = one(azurerm_private_endpoint.key_vault.private_service_connection[*].private_ip_address)
  description = "The private IP address of the private endpoint used by the Key Vault."
}

output "network_security_group_id" {
  value       = azurerm_network_security_group.this.id
  description = "The ID of the Azure Network Security Group (NSG) associated with the Launchpad."
}

output "network_security_group_name" {
  value       = azurerm_network_security_group.this.name
  description = "The name of the Azure Network Security Group (NSG) associated with the Launchpad."
}

output "subnet_id" {
  value       = local.subnet_id
  description = "The ID of the subnet within the Virtual Network, associated with the Launchpad production environment."
}

output "subnet_name" {
  value       = var.subnet_id == null ? azurerm_subnet.this[0].name : split("/", var.subnet_id)[10]
  description = "The name of the subnet within the Virtual Network, associated with the Launchpad production environment in case."
}

output "virtual_network_id" {
  value = (var.subnet_id == null ? azurerm_virtual_network.this[0].id :
  join("/", slice(split("/", var.subnet_id), 0, 9)))
  description = "The ID of the Azure Virtual Network (VNet) associated with the Launchpad."
}

output "virtual_network_name" {
  value       = var.subnet_id == null ? azurerm_virtual_network.this[0].name : split("/", var.subnet_id)[8]
  description = "The name of the Azure Virtual Network (VNet) associated with the Launchpad."
}

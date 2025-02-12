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
  value       = var.create_key_vault ? (azurerm_private_endpoint.key_vault[0].private_service_connection[*].private_ip_address) : null
  description = "The private IP address of the private endpoint associated with the Key Vault. This endpoint is created only if `create_key_vault` is set to `true`. If `create_key_vault` is `false`, this output will be `null`."
}

output "network_security_group_id" {
  value       = (var.subnet_id == null ? azurerm_network_security_group.this[0].id : null)
  description = "The ID of the Azure Network Security Group (NSG) associated with the Launchpad. If `var.subnet_id` is specified, no Azure Network Security Group (NSG) ID is returned."
}

output "network_security_group_name" {
  value       = (var.subnet_id == null ? azurerm_network_security_group.this[0].name : null)
  description = "The name of the Azure Network Security Group (NSG) associated with the Launchpad. If `var.subnet_id` is specified, no Azure Network Security Group (NSG) Name is returned."
}

output "subnet_id" {
  value       = local.subnet_id
  description = "The ID of the subnet within the Virtual Network associated with the Launchpad. If `var.subnet_id` is specified, its value is used for this output. Otherwise, the ID of the subnet created by this module is returned."
}

output "subnet_name" {
  value       = var.subnet_id == null ? azurerm_subnet.this[0].name : split("/", var.subnet_id)[10]
  description = "The name of the subnet within the Virtual Network associated with the Launchpad. If `var.subnet_id` is not specified, the name of the subnet created by this module is returned. Otherwise, the name is extracted from the specified `var.subnet_id`."
}

output "virtual_network_id" {
  value = (var.subnet_id == null ? azurerm_virtual_network.this[0].id :
  join("/", slice(split("/", var.subnet_id), 0, 9)))
  description = "The ID of the Azure Virtual Network (VNet) associated with the Launchpad. If `var.subnet_id` is not specified, the ID of the Virtual Network created by this module is returned. Otherwise, the Virtual Network ID is derived from the specified `var.subnet_id`."
}

output "virtual_network_name" {
  value       = var.subnet_id == null ? azurerm_virtual_network.this[0].name : split("/", var.subnet_id)[8]
  description = "The name of the Azure Virtual Network (VNet) associated with the Launchpad. If `var.subnet_id` is not specified, the name of the Virtual Network created by this module is returned. Otherwise, the name is extracted from the specified `var.subnet_id`."
}

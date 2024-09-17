output "LAUNCHPAD_AZURE_CLIENT_ID" {
  value = azurerm_user_assigned_identity.this.client_id
}

output "LAUNCHPAD_AZURE_TENANT_ID" {
  value = azurerm_user_assigned_identity.this.tenant_id
}

output "LAUNCHPAD_AZURE_STORAGE_ACCOUNT_NAME" {
  value = azurerm_storage_account.this.name
}

output "location" {
  value = var.location
}

output "vnet_name" {
  value = azurerm_virtual_network.this.name
}

output "vnet_id" {
  value = azurerm_virtual_network.this.id
}

output "subnet_name" {
  value = azurerm_subnet.snet_launchpad_prd.name
}

output "subnet_id" {
  value = azurerm_subnet.snet_launchpad_prd.id
}

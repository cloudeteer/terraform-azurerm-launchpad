output "ARM_CLIENT_ID" {
  value = azurerm_user_assigned_identity.this.client_id
}

output "tfstate_storage_account_name" {
  value = azurerm_storage_account.this.name
}

output "key_vault_name" {
  value = azurerm_key_vault.this.name
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

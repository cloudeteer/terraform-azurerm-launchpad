output "ARM_CLIENT_ID" {
  value = azurerm_user_assigned_identity.id_launchpad_prd.client_id
}

output "tfstate_storage_account_name" {
  value = azurerm_storage_account.stlaunchpadprd.name
}

output "key_vault_name" {
  value = azurerm_key_vault.kvlaunchpadprd.name
}

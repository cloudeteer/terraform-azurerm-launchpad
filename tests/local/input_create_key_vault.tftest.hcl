mock_provider "azurerm" {
  source = "./tests/local/mocks"
}

run "should_succeed_without_key_vault_creation" {
  command = plan

  variables {
    create_key_vault = false
  }

  assert {
    condition     = length(azurerm_key_vault.this) == 0
    error_message = "Expected that the Key Vault resource will not be created"
  }

  assert {
    condition     = length(random_string.kvlaunchpadprd_suffix) == 0
    error_message = "Expected that the random string for Key Vault suffix will not be created"
  }

  assert {
    condition     = length(azurerm_management_lock.key_vault_lock) == 0
    error_message = "Expected that the Key Vault management lock will not be created"
  }

  assert {
    condition     = length(azurerm_private_endpoint.key_vault) == 0
    error_message = "Expected that the Key Vault private endpoint will not be created"
  }

  assert {
    condition     = length(azurerm_role_assignment.key_vault_admin_current_user) == 0
    error_message = "Expected that the Key Vault admin role assignment for the current user will not be created"
  }
}

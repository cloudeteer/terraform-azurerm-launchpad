mock_provider "azurerm" {
  source = "./tests/local/mocks"
}

run "should_succeed_without_key_vault_creation" {
  command = plan

  variables {
    name_overrides = {
      for resource in [
        "key_vault",
        "key_vault_private_endpoint",
        "virtual_machine_scale_set_name",
        "network_security_group",
        "storage_account",
        "storage_container",
        "storage_private_endpoint",
        "subnet",
        "user_assigned_identity",
        "virtual_network",
      ] : resource => "tftest"
    }
  }

  assert {
    condition = alltrue([for resource in [
      azurerm_key_vault.this,
      azurerm_private_endpoint.key_vault,
      azurerm_linux_virtual_machine_scale_set.this,
      azurerm_network_security_group.this,
      azurerm_storage_account.this,
      azurerm_storage_container.this,
      azurerm_private_endpoint.storage_account,
      azurerm_subnet.this,
      azurerm_user_assigned_identity.this,
      azurerm_virtual_network.this,
      ] : one(resource[*].name) == "tftest"
    ])
    error_message = "Expected the name of the resource to be overwritten with the value \"tftest\"."
  }
}

mock_provider "azurerm" {
  source = "./tests/local/mocks"
}

run "succeed_without_key_vault_creation" {
  command = plan

  variables {
    create_key_vault = false
  }
}

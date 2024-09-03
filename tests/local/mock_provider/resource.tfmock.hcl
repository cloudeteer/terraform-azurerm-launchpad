######################
##### Resources ######
######################

mock_resource "azurerm_user_assigned_identity" {
  defaults = {
    id = "/subscriptions/12345678-1234-9876-4563-123456789012/resourceGroups/RG-MOCK/providers/Microsoft.ManagedIdentity/userAssignedIdentities/ID-MOCK"
  }
}

mock_resource "azurerm_role_assignment" {
  defaults = {
    id = "/subscriptions/00000000-0000-0000-0000-000000000000/providers/Microsoft.Authorization/roleAssignments/00000000-0000-0000-0000-000000000000|00000000-0000-0000-0000-000000000000"
  }
}
mock_resource "azurerm_subnet" {
  defaults = {
    id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/RG-MOCK/providers/Microsoft.Network/virtualNetworks/virtualNetworksValue/subnets/SNET-MOCK"
  }
}
mock_resource "azurerm_key_vault" {
  defaults = {
    id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/RG-MOCK/providers/Microsoft.KeyVault/vaults/KV-MOCK"
  }
}

mock_resource "azurerm_storage_account" {
  defaults = {
    id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/RG-MOCK/providers/Microsoft.Storage/storageAccounts/STMOCK"
  }
}

mock_resource "azurerm_network_security_group" {
  defaults = {
    id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/RG-MOCK/providers/Microsoft.Network/networkSecurityGroups/NSG-MOCK"
  }
}

#################
##### Data ######
#################

mock_data "azurerm_client_config" {
  defaults = {
    tenant_id = "00000000-0000-0000-0000-000000000000"
    object_id = "00000000-0000-0000-0000-000000000000"
  }
}

mock_data "azurerm_management_group" {
  defaults = {
    id   = "/providers/Microsoft.Management/managementGroups/AMG-MOCK"
    name = "cdt-mgmt"
  }
}

mock_data "azurerm_subscription"{
  defaults = {
      id   = "/subscriptions/12345678-1234-9876-4563-123456789012"
      name = "Subscription 1"
    }
}

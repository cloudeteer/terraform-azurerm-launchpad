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

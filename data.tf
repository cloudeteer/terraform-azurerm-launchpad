data "azurerm_client_config" "current" {}

data "azuread_user" "current_user" {
  object_id = data.azurerm_client_config.current.object_id
}

data "azurerm_management_group" "id_launchpad_prd_mg_scope" {
  for_each = toset(local.management_groups)
  name     = each.key
}

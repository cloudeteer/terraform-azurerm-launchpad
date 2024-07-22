data "azurerm_client_config" "current" {}

data "azurerm_management_group" "id_launchpad_prd_mg_scope" {
  for_each = toset(local.management_groups)
  name     = each.key
}

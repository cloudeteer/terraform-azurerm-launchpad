data "azurerm_client_config" "current" {}

data "azurerm_management_group" "id_launchpad_prd_mg_scope" {
  for_each = toset(var.management_groups)
  name     = each.key
}

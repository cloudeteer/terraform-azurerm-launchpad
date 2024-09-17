data "azurerm_client_config" "current" {}

data "azurerm_subscription" "id_launchpad_prd_sub_scope" {
  for_each        = toset(var.subscription_ids)
  subscription_id = each.key
}

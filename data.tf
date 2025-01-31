data "azurerm_client_config" "current" {}

data "azurerm_subscription" "managed_by_launchpad" {
  for_each        = toset(concat(var.subscription_ids, [data.azurerm_client_config.current.subscription_id]))
  subscription_id = each.key
}

data "azurerm_management_group" "managed_by_launchpad" {
  for_each = toset(var.management_group_names)
  name     = each.value
}

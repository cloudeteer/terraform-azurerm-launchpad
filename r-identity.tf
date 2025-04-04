locals {
  user_assigned_identity_name = coalesce(
    var.name_overrides.user_assigned_identity,
    join("-", compact([
      "id", var.name, "prd", local.location_short[var.location], var.name_suffix
    ]))
  )
}

resource "azurerm_user_assigned_identity" "this" {
  name                = local.user_assigned_identity_name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_federated_identity_credential" "this" {
  for_each = var.runner_github_environments

  name = each.key

  audience            = ["api://AzureADTokenExchange"]
  issuer              = "https://token.actions.githubusercontent.com"
  parent_id           = azurerm_user_assigned_identity.this.id
  resource_group_name = azurerm_user_assigned_identity.this.resource_group_name
  subject             = "repo:${var.runner_github_repo}:environment:${each.value}"
}


resource "azurerm_role_assignment" "management_group_owner" {
  for_each = data.azurerm_management_group.managed_by_launchpad

  principal_id         = azurerm_user_assigned_identity.this.principal_id
  role_definition_name = var.role_definition_name
  scope                = each.value.id
}

resource "azurerm_role_assignment" "subscription_owner" {
  for_each = data.azurerm_subscription.managed_by_launchpad

  principal_id         = azurerm_user_assigned_identity.this.principal_id
  role_definition_name = var.role_definition_name
  scope                = each.value.id
}

resource "azurerm_role_assignment" "resource_specific" {
  for_each = var.create_role_assignments ? {
    for key, value in {
      storage_blob_owner = {
        role_definition_name = "Storage Blob Data Owner"
        scope                = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/${var.resource_group_name}"
      },
      key_vault_admin = var.create_key_vault ? {
        role_definition_name = "Key Vault Administrator"
        scope                = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/${var.resource_group_name}"
      } : null
  } : key => value if value != null } : {}


  principal_id         = azurerm_user_assigned_identity.this.principal_id
  scope                = each.value.scope
  role_definition_name = each.value.role_definition_name
}

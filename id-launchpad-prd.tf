locals {
  management_groups = []
  role              = "Owner"
}

resource "azurerm_user_assigned_identity" "id_launchpad_prd" {
  name                = "id-launchpad-prd-${local.location_short[var.location]}"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = local.tags
}

resource "azurerm_federated_identity_credential" "id_launchpad_prd_github_env" {
  for_each = {
    prod-azure      = "prod-azure"
    prod-azure-plan = "prod-azure (plan)"
  }

  name = each.key

  audience            = ["api://AzureADTokenExchange"]
  issuer              = "https://token.actions.githubusercontent.com"
  parent_id           = azurerm_user_assigned_identity.id_launchpad_prd.id
  resource_group_name = azurerm_user_assigned_identity.id_launchpad_prd.resource_group_name
  subject             = "repo:${var.runner_github_repo}:environment:${each.value}"
}

resource "azurerm_role_assignment" "id_launchpad_prd_mg_scope" {
  for_each = toset(local.management_groups)

  principal_id         = azurerm_user_assigned_identity.id_launchpad_prd.principal_id
  role_definition_name = local.role
  scope                = data.azurerm_management_group.id_launchpad_prd_mg_scope[each.key].id
}

resource "azurerm_role_assignment" "id_launchpad_prd_current_subscription" {
  principal_id         = azurerm_user_assigned_identity.id_launchpad_prd.principal_id
  role_definition_name = "Owner"
  scope                = "/subscriptions/${data.azurerm_client_config.current.subscription_id}"
}

resource "azurerm_role_assignment" "id_launchpad_prd_rg_launchpad_blob_owner" {
  principal_id         = azurerm_user_assigned_identity.id_launchpad_prd.principal_id
  role_definition_name = "Storage Blob Data Owner"
  scope                = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/${var.resource_group_name}"
}

resource "azurerm_role_assignment" "id_launchpad_prd_rg_launchpad_key_vault_administrator" {
  principal_id         = azurerm_user_assigned_identity.id_launchpad_prd.principal_id
  role_definition_name = "Key Vault Administrator"
  scope                = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/${var.resource_group_name}"
}

resource "azurerm_user_assigned_identity" "this" {
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
  parent_id           = azurerm_user_assigned_identity.this.id
  resource_group_name = azurerm_user_assigned_identity.this.resource_group_name
  subject             = "repo:${var.runner_github_repo}:environment:${each.value}"
}

data "azurerm_management_group" "mg_owner" {
  for_each = toset(var.management_groups)
  name     = each.value
}

resource "azurerm_role_assignment" "mg_owner" {
  for_each = data.azurerm_management_group.mg_owner

  principal_id         = azurerm_user_assigned_identity.this.principal_id
  role_definition_name = "Owner"
  scope                = each.value.id
}

resource "azurerm_role_assignment" "this" {
  for_each = {
    owner = {
      scope                = "/subscriptions/${data.azurerm_client_config.current.subscription_id}"
      role_definition_name = "Owner"
    },
    storage_blob_owner = {
      role_definition_name = "Storage Blob Data Owner"
      scope                = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/${var.resource_group_name}"
    },
    key_vault_admin = {
      role_definition_name = "Key Vault Administrator"
      scope                = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/${var.resource_group_name}"
    }
  }

  principal_id         = azurerm_user_assigned_identity.this.principal_id
  scope                = each.value.scope
  role_definition_name = each.value.role_definition_name
}



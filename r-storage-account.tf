locals {
  storage_account_name = coalesce(
    var.name_overrides.storage_account,
    join("", compact([
      "st", var.name, "prd", local.location_short[var.location], one(random_string.stlaunchpadprd_suffix[*].result)
    ]))
  )

  storage_container_name = coalesce(var.name_overrides.storage_container, "tfstate")

  storage_private_endpoint_name = coalesce(
    var.name_overrides.storage_private_endpoint,
    join("-", compact([
      "pe", azurerm_storage_account.this.name, "prd", local.location_short[var.location], var.name_suffix
    ]))
  )
}

resource "random_string" "stlaunchpadprd_suffix" {
  count = var.name_overrides.storage_account != null ? 0 : 1

  length  = 3
  special = false
  upper   = false
}

resource "azurerm_management_lock" "storage_account_lock" {
  count      = !var.storage_account_deletion_lock ? 0 : 1
  name       = "storage_account_lock"
  scope      = azurerm_storage_account.this.id
  lock_level = "CanNotDelete"
  notes      = "This lock prevents the deletion of the Storage Account, which contains critical infrastructure information."
}

resource "azurerm_storage_account" "this" {
  name                = local.storage_account_name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  account_kind             = "StorageV2"
  account_tier             = "Standard"
  account_replication_type = "RAGRS"

  allow_nested_items_to_be_public   = false
  cross_tenant_replication_enabled  = false
  default_to_oauth_authentication   = true
  https_traffic_only_enabled        = true
  infrastructure_encryption_enabled = true
  is_hns_enabled                    = false
  large_file_share_enabled          = false
  min_tls_version                   = "TLS1_2"
  public_network_access_enabled     = var.storage_account_public_network_access_enabled
  shared_access_key_enabled         = false

  dynamic "network_rules" {
    for_each = var.storage_account_public_network_access_enabled && length(var.storage_account_public_network_access_ip_rules) > 0 ? [true] : []
    content {
      default_action = "Deny"
      ip_rules       = var.storage_account_public_network_access_ip_rules
      bypass         = ["AzureServices"]
    }
  }

  blob_properties {
    versioning_enabled = true
  }

  lifecycle {
    ignore_changes = [network_rules[0].private_link_access]
  }
}

resource "azurerm_storage_container" "this" {
  name                  = local.storage_container_name
  storage_account_name  = azurerm_storage_account.this.name
  container_access_type = "private"
}

resource "azurerm_private_endpoint" "storage_account" {
  count = var.create_private_runner ? 1 : 0

  name                = local.storage_private_endpoint_name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  subnet_id = local.subnet_id

  private_service_connection {
    name                           = "blob"
    private_connection_resource_id = azurerm_storage_account.this.id
    subresource_names              = ["blob"]
    is_manual_connection           = false
  }
}

resource "azurerm_role_assignment" "storage_account_blob_owner_current_user" {
  count = var.grant_access_to_storage_account ? 1 : 0

  description          = "Temporary role assignment. Delete this assignment if unsure why it is still existing."
  principal_id         = local.grant_access_to_azure_principal_id
  role_definition_name = "Storage Blob Data Owner"
  scope                = azurerm_storage_account.this.id
}

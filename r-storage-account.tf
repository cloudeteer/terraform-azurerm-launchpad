resource "random_string" "stlaunchpadprd_suffix" {
  length  = 3
  special = false
  upper   = false
}

resource "azurerm_management_lock" "storage_account_lock" {
  count      = var.init ? 0 : 1
  name       = "storage_account_lock"
  scope      = azurerm_storage_account.this.id
  lock_level = "CanNotDelete"
  notes      = "For safety reasons, the Storage Account can not be deleted."
}

resource "azurerm_storage_account" "this" {
  name = join("", compact([
    "st", var.name, "prd", local.location_short[var.location], random_string.stlaunchpadprd_suffix.result
  ]))
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
  public_network_access_enabled     = var.init ? true : false
  shared_access_key_enabled         = false

  dynamic "network_rules" {
    for_each = var.init ? [true] : []
    content {
      default_action = "Deny"
      ip_rules       = [var.init_access_ip_address]
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
  name                  = "tfstate"
  storage_account_name  = azurerm_storage_account.this.name
  container_access_type = "private"
}

resource "azurerm_private_endpoint" "storage_account" {
  name = join("-", compact([
    "pe", azurerm_storage_account.this.name, "prd", local.location_short[var.location], var.name_suffix
  ]))
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
  count = var.init ? 1 : 0

  description          = "Temporary role assignment. Delete this assignment if unsure why it is still existing."
  principal_id         = local.init_access_azure_principal_id
  role_definition_name = "Storage Blob Data Owner"
  scope                = azurerm_storage_account.this.id
}

resource "random_string" "stlaunchpadprd_suffix" {
  length  = 3
  special = false
  upper   = false
}

resource "azurerm_storage_account" "this" {
  name                = "stlaunchpadprd${local.location_short[var.location]}${random_string.stlaunchpadprd_suffix.result}"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  account_kind             = "StorageV2"
  account_tier             = "Standard"
  account_replication_type = "RAGRS"

  cross_tenant_replication_enabled  = false
  default_to_oauth_authentication   = true
  enable_https_traffic_only         = true
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
    prevent_destroy = true
    ignore_changes  = [network_rules[0].private_link_access]
  }
}

resource "azurerm_storage_container" "stlaunchpadprd_tfstate" {
  name                  = "tfstate"
  storage_account_name  = azurerm_storage_account.this.name
  container_access_type = "private"
}

resource "azurerm_private_endpoint" "pe_stlaunchpadprd_prd" {
  name                = "pe-${azurerm_storage_account.this.name}-prd-${local.location_short[var.location]}"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  subnet_id = azurerm_subnet.snet_launchpad_prd.id

  private_service_connection {
    name                           = "blob"
    private_connection_resource_id = azurerm_storage_account.this.id
    subresource_names              = ["blob"]
    is_manual_connection           = false
  }
}

resource "azurerm_role_assignment" "stlaunchpadprd_current_client_blob_owner" {
  count = var.init ? 1 : 0

  description          = "Temporary role assignment. Delete this assignment if unsure why it is still existing."
  principal_id         = local.init_access_azure_principal_id
  role_definition_name = "Storage Blob Data Owner"
  scope                = azurerm_storage_account.this.id
}

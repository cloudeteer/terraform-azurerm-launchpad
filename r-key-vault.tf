resource "random_string" "kvlaunchpadprd_suffix" {
  length  = 3
  special = false
  upper   = false
}

locals {
  key_vault_private_link_enabled = length((var.key_vault_virtual_network_subnet_ids)) > 0
}

resource "azurerm_key_vault" "this" {
  name = join("", compact([
    "kv", var.name, "prd", local.location_short[var.location], random_string.kvlaunchpadprd_suffix.result
  ]))
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  tenant_id = data.azurerm_client_config.current.tenant_id

  enable_rbac_authorization     = true
  public_network_access_enabled = var.init ? true : false
  purge_protection_enabled      = true
  sku_name                      = "standard"
  soft_delete_retention_days    = 30

  network_acls {
    bypass                     = local.key_vault_private_link_enabled ? "AzureServices" : "None"
    default_action             = "Deny"
    ip_rules                   = var.init ? [var.init_access_ip_address] : []
    virtual_network_subnet_ids = local.key_vault_private_link_enabled ? var.key_vault_virtual_network_subnet_ids : null
  }
}

resource "azurerm_private_endpoint" "key_vault" {
  name = join("-", compact([
    "pe", azurerm_key_vault.this.name, "prd", local.location_short[var.location], var.name_suffix
  ]))
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  subnet_id = local.current_subnet_id

  private_service_connection {
    name                           = "vault"
    private_connection_resource_id = azurerm_key_vault.this.id
    subresource_names              = ["vault"]
    is_manual_connection           = false
  }

  dynamic "private_dns_zone_group" {
    for_each = length(var.key_vault_private_dns_zone_ids) > 0 ? [1] : []
    content {
      name                 = "default"
      private_dns_zone_ids = var.key_vault_private_dns_zone_ids
    }
  }
}

resource "azurerm_role_assignment" "key_vault_admin_current_user" {
  count = var.init ? 1 : 0

  description          = "Temporary role assignment. Delete this assignment if unsure why it is still existing."
  principal_id         = local.init_access_azure_principal_id
  role_definition_name = "Key Vault Administrator"
  scope                = azurerm_key_vault.this.id
}

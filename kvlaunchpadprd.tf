resource "random_string" "kvlaunchpadprd_suffix" {
  length  = 3
  special = false
  upper   = false
}

resource "azurerm_key_vault" "kvlaunchpadprd" {
  name                = "kvlaunchpadprd${local.location_short[var.location]}${random_string.kvlaunchpadprd_suffix.result}"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = local.tags

  tenant_id = data.azurerm_client_config.current.tenant_id

  enable_rbac_authorization     = true
  public_network_access_enabled = var.init ? true : false
  purge_protection_enabled      = true
  sku_name                      = "standard"
  soft_delete_retention_days    = 30

  network_acls {
    default_action = "Deny"
    bypass         = "None"
    ip_rules       = var.init ? [var.init_access_ip_address] : []
  }
}

resource "azurerm_private_endpoint" "pe_kvlaunchpadprd_prd" {
  name                = "pe-${azurerm_key_vault.kvlaunchpadprd.name}-prd-${local.location_short[var.location]}"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = local.tags

  subnet_id = azurerm_subnet.snet_launchpad_prd.id

  private_service_connection {
    name                           = "vault"
    private_connection_resource_id = azurerm_key_vault.kvlaunchpadprd.id
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

resource "azurerm_role_assignment" "kvlaunchpadprd_current_client_key_vault_administrator" {
  count = var.init ? 1 : 0

  description          = "Temporary role assignment. Delete this assignment if unsure why it is still existing."
  principal_id         = local.init_access_azure_principal_id
  role_definition_name = "Key Vault Administrator"
  scope                = azurerm_key_vault.kvlaunchpadprd.id
}

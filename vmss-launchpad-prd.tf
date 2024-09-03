locals {
  admin_username = "azureadmin"
  github_runner_script = base64gzip(templatefile("assets/install_github_actions_runner.sh.tftpl", {
    key_vault_hostname                  = "${azurerm_key_vault.this.name}.vault.azure.net"
    private_endpoint_key_vault_ip       = one(azurerm_private_endpoint.pe_kvlaunchpadprd_prd.private_service_connection[*].private_ip_address)
    private_endpoint_storage_account_ip = one(azurerm_private_endpoint.pe_stlaunchpadprd_prd.private_service_connection[*].private_ip_address)
    storage_account_hostname            = azurerm_storage_account.this.primary_blob_host

    runner_arch        = var.runner_arch
    runner_count       = var.runner_count
    runner_github_pat  = var.runner_github_pat
    runner_github_repo = var.runner_github_repo
    runner_user        = var.runner_user
    runner_version     = var.runner_version
  }))
}

resource "azurerm_linux_virtual_machine_scale_set" "vmss_launchpad_prd" {
  name                = "vmss-launchpad-prd-${local.location_short[var.location]}"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  admin_password                  = random_password.vmss_launchpad_prd_azureadmin_password.result
  admin_username                  = local.admin_username
  computer_name_prefix            = "vm-launchpad"
  disable_password_authentication = false
  instances                       = var.runner_vm_instances
  sku                             = "Standard_D2plds_v5"
  encryption_at_host_enabled      = false

  automatic_os_upgrade_policy {
    disable_automatic_rollback  = false
    enable_automatic_os_upgrade = false
  }

  automatic_instance_repair {
    enabled = true
  }

  boot_diagnostics {
    storage_account_uri = null
  }

  rolling_upgrade_policy {
    max_batch_instance_percent              = 100
    max_unhealthy_instance_percent          = 100
    max_unhealthy_upgraded_instance_percent = 100
    pause_time_between_batches              = "PT0M"
  }

  extension_operations_enabled = true
  extensions_time_budget       = "PT15M"
  provision_vm_agent           = true
  upgrade_mode                 = "Automatic"
  secure_boot_enabled          = false
  vtpm_enabled                 = false
  overprovision                = true

  # trigger instance update
  custom_data = base64encode("#cloud-config\n#${sha256(local.github_runner_script)}")

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-arm64"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadOnly"
    disk_size_gb         = 49

    diff_disk_settings {
      option    = "Local"
      placement = "CacheDisk"
    }
  }

  network_interface {
    name    = "primary"
    primary = true

    ip_configuration {
      name      = "internal"
      primary   = true
      subnet_id = azurerm_subnet.snet_launchpad_prd.id

      dynamic "public_ip_address" {
        for_each = var.runner_public_ip_address ? [true] : []
        content {
          name = "public"
        }
      }
    }
  }

  extension {
    name                 = "github-actions-runner"
    publisher            = "Microsoft.Azure.Extensions"
    type                 = "CustomScript"
    type_handler_version = "2.0"

    settings = jsonencode({
      "skipDos2Unix" : true
    })

    protected_settings = jsonencode({
      "script" = local.github_runner_script
    })
  }

  extension {
    name                      = "health"
    publisher                 = "Microsoft.ManagedServices"
    type                      = "ApplicationHealthLinux"
    automatic_upgrade_enabled = true
    type_handler_version      = "1.0"

    settings = jsonencode({
      protocol = "tcp"
      port     = 22
    })
  }

  lifecycle {
    prevent_destroy = true
  }
}

resource "random_password" "vmss_launchpad_prd_azureadmin_password" {
  length = 30
}

#trivy:ignore:avd-azu-0017
#trivy:ignore:avd-azu-0013
resource "azurerm_key_vault_secret" "vmss_launchpad_prd_azureadmin_password" {

  name = "${azurerm_linux_virtual_machine_scale_set.vmss_launchpad_prd.name}-${azurerm_linux_virtual_machine_scale_set.vmss_launchpad_prd.admin_username}-password"

  content_type = "Password"
  key_vault_id = azurerm_key_vault.this.id
  value        = random_password.vmss_launchpad_prd_azureadmin_password.result
}

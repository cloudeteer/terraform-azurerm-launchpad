locals {
  admin_username = "azureadmin"
  github_runner_script = base64gzip(templatefile("${path.module}/assets/install_github_actions_runner.sh.tftpl", {
    key_vault_hostname                  = var.create_key_vault ? "${azurerm_key_vault.this[0].name}.vault.azure.net" : "_key_vault_deployment_disabled_.localhost.local"
    private_endpoint_key_vault_ip       = var.create_key_vault ? one(azurerm_private_endpoint.key_vault[0].private_service_connection[*].private_ip_address) : "127.0.0.1"
    private_endpoint_storage_account_ip = one(azurerm_private_endpoint.storage_account.private_service_connection[*].private_ip_address)
    storage_account_hostname            = azurerm_storage_account.this.primary_blob_host

    runner_arch        = var.runner_arch
    runner_count       = var.runner_count
    runner_github_pat  = var.runner_github_pat
    runner_github_repo = var.runner_github_repo
    runner_user        = var.runner_user
    runner_version     = var.runner_version
  }))

  virtual_machine_scale_set_name = coalesce(
    var.name_overrides.virtual_machine_scale_set_name,
    join("-", compact(["vmss", var.name, "prd", local.location_short[var.location], var.name_suffix]))
  )
}

resource "azurerm_linux_virtual_machine_scale_set" "this" {
  name                = local.virtual_machine_scale_set_name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  admin_password                  = random_password.virtual_machine_scale_set_admin_password.result
  admin_username                  = local.admin_username
  computer_name_prefix            = "vm-${var.name}"
  disable_password_authentication = false
  instances                       = var.runner_vm_instances
  sku                             = "Standard_D2plds_v5"
  encryption_at_host_enabled      = false

  automatic_instance_repair {
    enabled      = true
    grace_period = "PT10M"
  }

  boot_diagnostics {
    storage_account_uri = null
  }

  extension_operations_enabled = true
  extensions_time_budget       = "PT15M"
  provision_vm_agent           = true
  upgrade_mode                 = "Manual"
  secure_boot_enabled          = false
  vtpm_enabled                 = false
  overprovision                = false

  # trigger instance update
  custom_data = base64encode("#cloud-config\n#${sha256(local.github_runner_script)}")

  # https://documentation.ubuntu.com/azure/en/latest/azure-how-to/instances/find-ubuntu-images/
  source_image_reference {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server-arm64"
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
      subnet_id = local.subnet_id

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
}

resource "random_password" "virtual_machine_scale_set_admin_password" {
  length = 30
}

#trivy:ignore:avd-azu-0017
#trivy:ignore:avd-azu-0013
resource "azurerm_key_vault_secret" "virtual_machine_scale_set_admin_password" {
  count = var.create_key_vault ? 1 : 0

  name = "${azurerm_linux_virtual_machine_scale_set.this.name}-${azurerm_linux_virtual_machine_scale_set.this.admin_username}-password"

  content_type = "Password"
  key_vault_id = azurerm_key_vault.this[0].id
  value        = random_password.virtual_machine_scale_set_admin_password.result

  depends_on = [azurerm_role_assignment.key_vault_admin_current_user]
}

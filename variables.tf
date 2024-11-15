variable "init" {
  type        = bool
  default     = false
  description = "Is used for initiating the module itself for the first time. For more information please go here https://github.com/cloudeteer/terraform-azurerm-launchpad/blob/main/INSTALL.md "
}

variable "init_access_azure_principal_id" {
  type    = string
  default = null
}

variable "init_access_ip_address" {
  type        = string
  default     = null
  description = "Set the IP Address of your current public IP in order to access the new created resources. For more information please go here https://github.com/cloudeteer/terraform-azurerm-launchpad/blob/main/INSTALL.md "

  validation {
    condition     = (var.init && var.init_access_ip_address != null) || (!var.init && var.init_access_ip_address == null)
    error_message = "init_access_ip_address ERROR!"
  }
}

variable "key_vault_private_dns_zone_ids" {
  type        = list(string)
  default     = []
  description = "A list of ID´s of DNS Zones in order to add the Private Endpoint of the Keyvault into your DNS Zones."
}

variable "location" {
  type        = string
  description = "The geographic location where the resources will be deployed. This is must be a region name supported by Azure."
}

variable "management_group_names" {
  type        = list(string)
  description = "A list of management group in order the Launchpad gets Owner-permission in these management-groups."
}

variable "name" {
  type        = string
  description = "The base name applied to all resources created by this module."
  default     = "launchpad"
}

variable "name_suffix" {
  type        = string
  description = <<-EOD
    An optional suffix appended to the base name for all resources created by this module.

    **NOTE**: This suffix is not applied to resources that use a randomly generated suffix (e.g., Key Vault and Storage Account).
  EOD
  default     = ""
}

variable "resource_group_name" {
  description = "The name of the resource group in which the virtual machine should exist. Changing this forces a new resource to be created."
  type        = string
}

variable "runner_arch" {
  type        = string
  default     = "arm64"
  description = "The CPU architecture to run the GitHub actions runner. Can be `x64` or `arm64`."

  validation {
    condition     = contains(["x64", "arm64"], var.runner_arch)
    error_message = "This architecture is not allowed. Please use 'x64' or 'arm64'"
  }
}

variable "runner_count" {
  type        = string
  default     = "5"
  description = "Specify the number of instances of a GitHub Action runner to install on a single virtual machine instance."
}

variable "runner_github_environments" {
  type = map(string)
  default = {
    prod-azure      = "prod-azure"
    prod-azure-plan = "prod-azure (plan)"
  }
  description = "List of Github environments used by federal identity."
}

variable "runner_github_pat" {
  type        = string
  sensitive   = true
  description = "GitHub PAT that will be used to register GitHub Action Runner tokens"
}

variable "runner_github_repo" {
  type        = string
  description = "Specify the GitHub repository owner and name seperated by `/` to register the action runner. e.g. `cloudeteer/squad-customer`"

  validation {
    error_message = "You must specify the GitHub organization e.g. cloudeteer/squad-customer."
    condition     = length(split("/", var.runner_github_repo)) == 2
  }
}

variable "runner_public_ip_address" {
  type        = bool
  default     = false
  description = "Set the value of this variable to `true` if you want to allocate a public IP address to each instance within the Virtual Machine Scale Set. Enabling this option may be necessary to establish internet access when a direct connection to a HUB is currently unavailable."
}

variable "runner_user" {
  type        = string
  default     = "actions-runner"
  description = "An unprivileged user to run the Runner application. If this user does not exist on the system, a new user will be created."
}

variable "runner_version" {
  type        = string
  default     = "latest"
  description = "Set a specific GitHub action runner version (without the `v` in the version string) or use `latest`."
}

variable "runner_vm_instances" {
  type        = string
  description = "Set the amount of VM´s in the Virtual Machine Sscale Set (VMSS). (Default '1')"
  default     = 1
}

variable "subnet_address_prefixes" {
  type        = list(string)
  description = "A list of IP address prefixes (CIDR blocks) to be assigned to the subnet. Each entry in the list represents a CIDR block used to define the address space of the subnet within the virtual network."
}

variable "subscription_ids" {
  type        = list(string)
  description = "A list of subscription IDs, which the Launchpad will manage.Each must be exactly 36 characters long."
  default     = []

  validation {
    condition     = alltrue([for id in var.subscription_ids : length(id) == 36])
    error_message = "Each subscription ID must be exactly 36 characters long."
  }
}

variable "tags" {
  description = "A mapping of tags which should be assigned to all resources in this module."

  type    = map(string)
  default = {}
}

variable "virtual_network_address_space" {
  type        = list(string)
  description = "A list of IP address ranges to be assigned to the virtual network (VNet). Each entry in the list represents a CIDR block used to define the address space of the VNet."
}

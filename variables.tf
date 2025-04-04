variable "create_key_vault" {
  type        = bool
  default     = true
  description = "Create a central Key Vault which can be used to store secrets and keys securely during workload deployments."
}

variable "create_role_assignments" {
  type        = bool
  default     = true
  description = "Determines whether to create role assignments for the specified management groups and subscriptions."

  validation {
    condition     = var.create_role_assignments ? true : length(var.management_group_names) == 0 && length(var.subscription_ids) == 0
    error_message = "When 'create_role_assignments' is set to 'false', 'management_group_names' and 'subscription_ids' must be empty."
  }
}

variable "create_subnet" {
  type        = bool
  default     = true
  description = <<-EOT
    Determines whether to create a new Virtual Network and Subnet.
    - Set to `true` to create a new Virtual Network and Subnet. In this case:
      - `subnet_id` must not be specified.
      - Both `subnet_address_prefixes` and `virtual_network_address_space` must be provided.
    - Set to `false` to use an existing Subnet. In this case:
      - `subnet_id` must be specified.
      - `subnet_address_prefixes` and `virtual_network_address_space` must not be provided.
  EOT

  validation {
    condition = var.create_subnet ? (
      # create_subnet = true
      length(var.subnet_address_prefixes) > 0 &&
      length(var.virtual_network_address_space) > 0 &&
      var.subnet_id == null
      ) : (
      # create_subnet = false
      length(var.subnet_address_prefixes) == 0 &&
      length(var.virtual_network_address_space) == 0 &&
      var.subnet_id != null
    )
    error_message = <<-EOT
      Invalid configuration for 'create_subnet':

      - When 'create_subnet' is set to 'true':
        - 'subnet_id' must not be specified.
        - Both 'subnet_address_prefixes' and 'virtual_network_address_space' must be provided.

      - When 'create_subnet' is set to 'false':
        - 'subnet_id' must be specified.
        - 'subnet_address_prefixes' and 'virtual_network_address_space' must not be provided.
    EOT
  }
}

variable "init" {
  type        = bool
  default     = false
  description = "Is used for initiating the module itself for the first time. For more information please go here https://github.com/cloudeteer/terraform-azurerm-launchpad/blob/main/INSTALL.md "
}

variable "init_access_azure_principal_id" {
  description = <<-EOD
    Set the Azure Principal ID which will be given access to the storage account and key vault.
    **NOTE**: This is only required when `init` is set to `true`.
  EOD
  type        = string
  default     = null
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

variable "key_vault_deletion_lock" {
  type        = bool
  description = "Whether a deletion lock should be applied to the Key Vault to prevent accidental deletion and ensure data loss prevention."
  default     = true
}

variable "key_vault_private_dns_zone_ids" {
  type        = list(string)
  default     = []
  description = "A list of ID´s of DNS Zones in order to add the Private Endpoint of the Keyvault into your DNS Zones."
}

variable "key_vault_virtual_network_subnet_ids" {
  type        = list(string)
  description = "A list of Subnet IDs that are allowed to access the Key Vault used by the Launchpad."
  default     = []
}

variable "location" {
  type        = string
  description = "The geographic location where the resources will be deployed. This is must be a region name supported by Azure."
}

variable "location_short" {
  description = "Map of location short codes to merge with the existing defaults"
  type        = map(string)
  default     = {}
}

variable "management_group_names" {
  type        = list(string)
  description = "A list of management group in order the Launchpad gets Owner-permission in these management-groups."
  default     = []
}

variable "name" {
  type        = string
  description = "The base name applied to all resources created by this module."
  default     = "launchpad"
}

variable "name_overrides" {
  description = "This variable allows you to overwrite generated names of most resources created by this module. This can be handy when importing existing resources to the Terraform state. e.g. using an existing storage Account but not bringing it into the module but import it into the state and let it be managed by the module."

  type = object({
    key_vault                      = optional(string)
    key_vault_private_endpoint     = optional(string)
    virtual_machine_scale_set_name = optional(string)
    network_security_group         = optional(string)
    storage_account                = optional(string)
    storage_container              = optional(string)
    storage_private_endpoint       = optional(string)
    subnet                         = optional(string)
    user_assigned_identity         = optional(string)
    virtual_network                = optional(string)
  })

  default = {}
}

variable "name_suffix" {
  type        = string
  description = <<-EOD
    An optional suffix appended to the base name for all resources created by this module.

    **NOTE**: This suffix is not applied to resources that use a randomly generated suffix (e.g., Key Vault and Storage Account).
  EOD
  default     = null
}

variable "resource_group_name" {
  description = "The name of the resource group in which the virtual machine should exist. Changing this forces a new resource to be created."
  type        = string
}

variable "role_definition_name" {
  type        = string
  description = "Specifies the role definition name to be assigned to the Launchpad. Allowed values: `Contributor` and `Owner`."
  default     = "Owner"

  validation {
    condition     = contains(["Contributor", "Owner"], var.role_definition_name)
    error_message = "Invalid role definition name. Allowed values are 'Contributor' and 'Owner'."
  }
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

variable "service_endpoints" {
  description = <<-EOD
    The list of Service endpoints to associate with the subnet. Possible values include: `Microsoft.AzureActiveDirectory`, `Microsoft.AzureCosmosDB`, `Microsoft.ContainerRegistry`, `Microsoft.EventHub`, `Microsoft.KeyVault`, `Microsoft.ServiceBus`, `Microsoft.Sql`, `Microsoft.Storage`, `Microsoft.Storage`.Global and `Microsoft.Web`.

  **NOTE**: In order to use `Microsoft.Storage.Global` service endpoint (which allows access to virtual networks in other regions), you must enable the `AllowGlobalTagsForStorage` feature in your subscription. This is currently a preview feature, please see the [official documentation](https://learn.microsoft.com/en-us/azure/storage/common/storage-network-security?tabs=azure-cli#enabling-access-to-virtual-networks-in-other-regions-preview) for more information.
  EOD

  type    = list(string)
  default = ["Microsoft.KeyVault", "Microsoft.Storage"]
}

variable "storage_account_deletion_lock" {
  type        = bool
  description = "Whether a deletion lock should be applied to the Storage Account to prevent accidental deletion and ensure data loss prevention."
  default     = true
}

variable "subnet_address_prefixes" {
  type        = list(string)
  description = "A list of IP address prefixes (CIDR blocks) to be assigned to the subnet. Each entry in the list represents a CIDR block used to define the address space of the subnet within the virtual network."
  default     = []
}

variable "subnet_id" {
  type        = string
  description = "The ID of an existing subnet where the Launchpad will be deployed. If `subnet_id` is specified, both `subnet_address_prefixes` and `virtual_network_address_space` must be not set. Conversely, if `subnet_id` is not specified, both `subnet_address_prefixes` and `virtual_network_address_space` must be provided."
  default     = null
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
  default     = []
}

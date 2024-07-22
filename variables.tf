variable "init" {
  type    = bool
  default = false
}

variable "init_access_azure_principal_id" {
  type    = string
  default = null
}

variable "init_access_ip_address" {
  type    = string
  default = null
}

variable "location" {
  type = string
}

variable "vnet_address_space" {
  type = list(string)
}

variable "snet_address_prefixes" {
  type = list(string)
}

variable "runner_arch" {
  type        = string
  default     = "arm64"
  description = "The CPU achitecture to run the GitHub actions runner. Can be `x64` or `arm64`."
}

variable "runner_count" {
  type        = string
  default     = "5"
  description = "Specify the number of instances of a GitHub Action runner to install on a single virtual machine instance."
}

variable "runner_public_ip_address" {
  type        = bool
  default     = false
  description = "Set the value of this variable to `true` if you want to allocate a public IP address to each instance within the Virtual Machine Scale Set. Enabling this option may be necessary to establish internet access when a direct connection to a HUB is currently unavailable."
}

variable "runner_github_pat" {
  type        = string
  description = "GitHub PAT that will be used to register GitHub Action Runner tokens"
}

variable "runner_github_repo" {
  type        = string
  description = "Specify the GitHub repository owner and name seperated by `/` to register the action runner. e.g. `cloudeteer/squad-customer`"

  validation {
    error_message = "You must specify the GitHub organization e.g. cloudeteer/squad-customer."
    condition     = can(regex("/", var.runner_github_repo))
  }
}

variable "runner_user" {
  type        = string
  default     = "actions-runner"
  description = "An unprivileged user to run the Runner application. If this user does not exist on the system, a new user will be created."
}

variable "resource_group_name" {
  type        = string
  default     = null
  description = "(Optional) Set the resource-group of the deployed resources, otherwise a new resource-group will be created"
}

variable "runner_version" {
  type        = string
  default     = "latest"
  description = "Set a specific GitHub action runner version (without the `v` in the version string) or use `latest`."
}

variable "key_vault_private_dns_zone_ids" {
  type    = list(string)
  default = []
}

locals {
  init_access_azure_principal_id = (
    var.init_access_azure_principal_id == null ?
    data.azurerm_client_config.current.object_id :
    var.init_access_azure_principal_id
  )
  tags = {
    # "backupclass"             = ""
    # "business-criticality"    = ""
    # "costcenter"              = ""
    # "department"              = ""
    # "deployment-type"         = ""
    # "environment"             = ""
    # "maintenance-window"      = ""
    # "opsapp"                  = ""
    # "opsinfra"                = ""
    # "owner"                   = ""
    # "service"                 = ""
    # "tier"                    = ""
    # "update-wave"             = ""

    "environment" = ""
    "opsinfra"    = ""
    "owner"       = ""
    "service"     = "iac-launchpad"
  }

  location_short = {
    germanywestcentral = "gwc"
    westeurope         = "euw"

  }
}
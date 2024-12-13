variable "my_runner_github_pat" {
  type        = string
  description = <<-DESCRIPTION
    GitHub Personal Access Token (PAT) used for authentication.
    This variable should be set during runtime using the environment variable `TF_VAR_my_runner_github_pat`.
  DESCRIPTION
}

variable "my_runner_github_repo" {
  type        = string
  description = <<-DESCRIPTION
    The GitHub repository where the runner will be registered.
    This variable should be set during runtime using the environment variable `TF_VAR_my_runner_github_repo`.
  DESCRIPTION
}

resource "azurerm_resource_group" "example" {
  location = "germanywestcentral"
  name     = "rg-example-dev-gwc-01"
}

module "example" {
  source = "cloudeteer/launchpad/azurerm"

  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location

  runner_github_pat  = var.my_runner_github_pat
  runner_github_repo = var.my_runner_github_repo

  virtual_network_address_space = ["10.0.0.0/16"]
  subnet_address_prefixes       = ["10.0.2.0/24"]

  #
  # During the initial deployment, set the following variables to `true` to grant access
  # to the Key Vault and Storage Account. This ensures that the user or service principal
  # executing the `terraform apply` command will have the necessary access permissions.
  #
  grant_access_to_key_vault       = true
  grant_access_to_storage_account = true

  storage_account_public_network_access_enabled  = true
  storage_account_public_network_access_ip_rules = []

  key_vault_public_network_access_enabled  = true
  key_vault_public_network_access_ip_rules = []
}

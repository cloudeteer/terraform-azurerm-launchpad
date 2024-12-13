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

  #
  # Do not deploy a private runner virtual machine. Instead, use the GitHub-hosted runner.
  # For public runner the Key Vault and Storage Account should be public.
  #
  create_private_runner                         = false
  create_subnet                                 = false
  storage_account_public_network_access_enabled = true
  key_vault_public_network_access_enabled       = true
}

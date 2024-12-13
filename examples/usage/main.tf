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
  management_group_names        = ["mg-example"]
}

# terraform-azurerm-launchpad

[![SemVer](https://img.shields.io/badge/SemVer-2.0.0-blue.svg)](CHANGELOG.md)
[![Keep a Changelog](https://img.shields.io/badge/changelog-Keep%20a%20Changelog%20v1.0.0-%23E05735)](CHANGELOG.md)
[![Contributor Covenant](https://img.shields.io/badge/Contributor%20Covenant-2.1-4baaaa.svg)](.github/CONTRIBUTION.md)

Terraform Module Template

<!-- BEGIN_TF_DOCS -->
## Usage

```hcl
resource "azurerm_resource_group" "example" {
  location = "germanywestcentral"
  name     = "example-resource-group"
}

module "example" {
  source                = "cloudeteer/launchpad/azurerm"
  github_pat = "" #
  vnet_address_space    = ["192.168.0.0/24"]
  snet_address_prefixes = ["192.168.0.0/24"]
  resource_group_name   = azurerm_resource_group.example.name
  location              = azurerm_resource_group.example.location
}
```

## Providers

| Name | Version |
|------|---------|
| azuread | n/a |
| azurerm | ~> 3.111.0 |
| random | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_federated_identity_credential.id_launchpad_prd_github_env](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/federated_identity_credential) | resource |
| [azurerm_key_vault.kvlaunchpadprd](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault) | resource |
| [azurerm_key_vault_secret.vmss_launchpad_prd_azureadmin_password](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_linux_virtual_machine_scale_set.vmss_launchpad_prd](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine_scale_set) | resource |
| [azurerm_network_security_group.nsg_launchpad_prd](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group) | resource |
| [azurerm_private_endpoint.pe_kvlaunchpadprd_prd](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) | resource |
| [azurerm_private_endpoint.pe_stlaunchpadprd_prd](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) | resource |
| [azurerm_role_assignment.id_launchpad_prd_current_subscription](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.id_launchpad_prd_mg_scope](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.id_launchpad_prd_rg_launchpad_blob_owner](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.id_launchpad_prd_rg_launchpad_key_vault_administrator](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.kvlaunchpadprd_current_client_key_vault_administrator](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.stlaunchpadprd_current_client_blob_owner](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_storage_account.stlaunchpadprd](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account) | resource |
| [azurerm_storage_container.stlaunchpadprd_tfstate](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_container) | resource |
| [azurerm_subnet.snet_launchpad_prd](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_subnet_network_security_group_association.snet_launchpad_prd](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_network_security_group_association) | resource |
| [azurerm_user_assigned_identity.id_launchpad_prd](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity) | resource |
| [azurerm_virtual_network.vnet_launchpad_prd](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) | resource |
| [random_password.vmss_launchpad_prd_azureadmin_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_string.kvlaunchpadprd_suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [random_string.stlaunchpadprd_suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [azuread_user.current_user](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/user) | data source |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_management_group.id_launchpad_prd_mg_scope](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/management_group) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| init | n/a | `bool` | `false` | no |
| init\_access\_azure\_principal\_id | n/a | `string` | `null` | no |
| init\_access\_ip\_address | n/a | `string` | `null` | no |
| key\_vault\_private\_dns\_zone\_ids | n/a | `list(string)` | `[]` | no |
| location | n/a | `string` | n/a | yes |
| resource\_group\_name | (Optional) Set the resource-group of the deployed resources, otherwise a new resource-group will be created | `string` | `null` | no |
| runner\_arch | The CPU achitecture to run the GitHub actions runner. Can be `x64` or `arm64`. | `string` | `"arm64"` | no |
| runner\_count | Specify the number of instances of a GitHub Action runner to install on a single virtual machine instance. | `string` | `"5"` | no |
| runner\_github\_pat | GitHub PAT that will be used to register GitHub Action Runner tokens | `string` | n/a | yes |
| runner\_github\_repo | Specify the GitHub repository owner and name seperated by `/` to register the action runner. e.g. `cloudeteer/squad-customer` | `string` | n/a | yes |
| runner\_public\_ip\_address | Set the value of this variable to `true` if you want to allocate a public IP address to each instance within the Virtual Machine Scale Set. Enabling this option may be necessary to establish internet access when a direct connection to a HUB is currently unavailable. | `bool` | `false` | no |
| runner\_version | Set a specific GitHub action runner version (without the `v` in the version string) or use `latest`. | `string` | `"latest"` | no |
| snet\_address\_prefixes | n/a | `list(string)` | n/a | yes |
| vnet\_address\_space | n/a | `list(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| ARM\_CLIENT\_ID | n/a |
| key\_vault\_name | n/a |
| tfstate\_storage\_account\_name | n/a |
<!-- END_TF_DOCS -->
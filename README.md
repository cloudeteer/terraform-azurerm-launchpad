<!-- markdownlint-disable first-line-h1 no-inline-html -->

> [!NOTE]
> This repository is publicly accessible as part of our open-source initiative. We welcome contributions from the community alongside our organization's primary development efforts.

---

# terraform-azurerm-launchpad

[![SemVer](https://img.shields.io/badge/SemVer-2.0.0-blue.svg)](CHANGELOG.md)
[![Keep a Changelog](https://img.shields.io/badge/changelog-Keep%20a%20Changelog%20v1.0.0-%23E05735)](CHANGELOG.md)
[![Contributor Covenant](https://img.shields.io/badge/Contributor%20Covenant-2.1-4baaaa.svg)](.github/CONTRIBUTION.md)

This module sets up the a Github repository with  first steps for working in an Azure environment in order to use Terraform and a private 

<!-- BEGIN_TF_DOCS -->
## Usage

```hcl
resource "azurerm_resource_group" "example" {
  location = "germanywestcentral"
  name     = "example-resource-group"
}

resource "azurerm_virtual_network" "example" {
  name                = "vnet-example-dev-we-01"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  address_space = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "example" {
  name                = "snet-example-dev-we-01"
  resource_group_name = azurerm_resource_group.example.name

  address_prefixes     = ["10.0.2.0/24"]
  virtual_network_name = azurerm_virtual_network.example.name
}

module "example" {
  source                = "cloudeteer/launchpad/azurerm"
  github_pat            = "justRandomChars"
  vnet_address_space    = azurerm_virtual_network.example.address_space[0]
  snet_address_prefixes = azurerm_subnet.example.address_prefixes[0]
  resource_group_name   = azurerm_resource_group.example.name
  location              = azurerm_resource_group.example.location
  management_groups     = ["mg-cdt"]
}
```

## Providers

| Name | Version |
|------|---------|
| azurerm | ~> 3.111 |
| random | ~> 3.6 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_federated_identity_credential.id_launchpad_prd_github_env](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/federated_identity_credential) | resource |
| [azurerm_key_vault.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault) | resource |
| [azurerm_key_vault_secret.vmss_launchpad_prd_azureadmin_password](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_linux_virtual_machine_scale_set.vmss_launchpad_prd](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine_scale_set) | resource |
| [azurerm_network_security_group.nsg_launchpad_prd](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group) | resource |
| [azurerm_private_endpoint.pe_kvlaunchpadprd_prd](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) | resource |
| [azurerm_private_endpoint.pe_stlaunchpadprd_prd](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) | resource |
| [azurerm_role_assignment.init_kvlaunchpadprd_current_client_key_vault_administrator](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.mg_owner](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.stlaunchpadprd_current_client_blob_owner](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_storage_account.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account) | resource |
| [azurerm_storage_container.stlaunchpadprd_tfstate](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_container) | resource |
| [azurerm_subnet.snet_launchpad_prd](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_subnet_network_security_group_association.snet_launchpad_prd](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_network_security_group_association) | resource |
| [azurerm_user_assigned_identity.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity) | resource |
| [azurerm_virtual_network.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) | resource |
| [random_password.vmss_launchpad_prd_azureadmin_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_string.kvlaunchpadprd_suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [random_string.stlaunchpadprd_suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_management_group.mg_owner](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/management_group) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| init | Is used for initiating the module itself for the first time. For more information please go here https://github.com/cloudeteer/terraform-azurerm-launchpad/blob/main/INSTALL.md | `bool` | `false` | no |
| init\_access\_azure\_principal\_id | n/a | `string` | `null` | no |
| init\_access\_ip\_address | Set the IP Address of your current public IP in order to access the new created resources. For more information please go here https://github.com/cloudeteer/terraform-azurerm-launchpad/blob/main/INSTALL.md | `string` | `null` | no |
| key\_vault\_private\_dns\_zone\_ids | A list of ID´s of DNS Zones in order to add the Private Endpoint of the Keyvault into your DNS Zones. | `list(string)` | `[]` | no |
| location | The geographic location where the resources will be deployed. This is must be a region name supported by Azure. | `string` | n/a | yes |
| management\_groups | A list of management group in order the Launchpad gets Owner-permission in these management-groups. | `list(string)` | n/a | yes |
| resource\_group\_name | (Optional) Set the resource-group of the deployed resources, otherwise a new resource-group will be created | `string` | `null` | no |
| runner\_arch | The CPU architecture to run the GitHub actions runner. Can be `x64` or `arm64`. | `string` | `"arm64"` | no |
| runner\_count | Specify the number of instances of a GitHub Action runner to install on a single virtual machine instance. | `string` | `"5"` | no |
| runner\_github\_pat | GitHub PAT that will be used to register GitHub Action Runner tokens | `string` | n/a | yes |
| runner\_github\_repo | Specify the GitHub repository owner and name seperated by `/` to register the action runner. e.g. `cloudeteer/squad-customer` | `string` | n/a | yes |
| runner\_public\_ip\_address | Set the value of this variable to `true` if you want to allocate a public IP address to each instance within the Virtual Machine Scale Set. Enabling this option may be necessary to establish internet access when a direct connection to a HUB is currently unavailable. | `bool` | `false` | no |
| runner\_user | An unprivileged user to run the Runner application. If this user does not exist on the system, a new user will be created. | `string` | `"actions-runner"` | no |
| runner\_version | Set a specific GitHub action runner version (without the `v` in the version string) or use `latest`. | `string` | `"latest"` | no |
| runner\_vm\_instances | Set the amount of VM´s in the Virtual Machine Sscale Set (VMSS). (Default '1') | `string` | `1` | no |
| snet\_address\_prefixes | A list of IP address prefixes (CIDR blocks) to be assigned to the subnet. Each entry in the list represents a CIDR block used to define the address space of the subnet within the virtual network. | `list(string)` | n/a | yes |
| vnet\_address\_space | A list of IP address ranges to be assigned to the virtual network (VNet). Each entry in the list represents a CIDR block used to define the address space of the VNet. | `list(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| ARM\_CLIENT\_ID | n/a |
| key\_vault\_name | n/a |
| location | n/a |
| subnet\_id | n/a |
| subnet\_name | n/a |
| tfstate\_storage\_account\_name | n/a |
| vnet\_id | n/a |
| vnet\_name | n/a |
<!-- END_TF_DOCS -->

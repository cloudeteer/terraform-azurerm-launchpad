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

This example demonstrates the usage of the launch-pad module with default settings. It sets up all necessary dependencies, including a resource group, virtual network, subnet to ensure seamless deployment.

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
  source = "cloudeteer/launchpad/azurerm"

  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location

  runner_github_pat  = "<valid_github_pat>"
  runner_github_repo = "cloudeteer/customer-repo"

  vnet_address_space    = azurerm_virtual_network.example.address_space
  snet_address_prefixes = azurerm_subnet.example.address_prefixes
  management_groups     = ["mg-cdt"]
}
```

## Providers

The following providers are used by this module:

- <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) (~> 3.111)

- <a name="provider_random"></a> [random](#provider\_random) (~> 3.6)



## Resources

The following resources are used by this module:

- [azurerm_federated_identity_credential.id_launchpad_prd_github_env](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/federated_identity_credential) (resource)
- [azurerm_key_vault.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault) (resource)
- [azurerm_key_vault_secret.vmss_launchpad_prd_azureadmin_password](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) (resource)
- [azurerm_linux_virtual_machine_scale_set.vmss_launchpad_prd](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine_scale_set) (resource)
- [azurerm_network_security_group.nsg_launchpad_prd](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group) (resource)
- [azurerm_private_endpoint.pe_kvlaunchpadprd_prd](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) (resource)
- [azurerm_private_endpoint.pe_stlaunchpadprd_prd](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) (resource)
- [azurerm_role_assignment.init_kvlaunchpadprd_current_client_key_vault_administrator](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) (resource)
- [azurerm_role_assignment.mg_owner](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) (resource)
- [azurerm_role_assignment.stlaunchpadprd_current_client_blob_owner](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) (resource)
- [azurerm_role_assignment.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) (resource)
- [azurerm_storage_account.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account) (resource)
- [azurerm_storage_container.stlaunchpadprd_tfstate](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_container) (resource)
- [azurerm_subnet.snet_launchpad_prd](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) (resource)
- [azurerm_subnet_network_security_group_association.snet_launchpad_prd](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_network_security_group_association) (resource)
- [azurerm_user_assigned_identity.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity) (resource)
- [azurerm_virtual_network.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) (resource)
- [random_password.vmss_launchpad_prd_azureadmin_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) (resource)
- [random_string.kvlaunchpadprd_suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) (resource)
- [random_string.stlaunchpadprd_suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) (resource)
- [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) (data source)
- [azurerm_management_group.mg_owner](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/management_group) (data source)

## Required Inputs

The following input variables are required:

### <a name="input_location"></a> [location](#input\_location)

Description: The geographic location where the resources will be deployed. This is must be a region name supported by Azure.

Type: `string`

### <a name="input_management_groups"></a> [management\_groups](#input\_management\_groups)

Description: A list of management group in order the Launchpad gets Owner-permission in these management-groups.

Type: `list(string)`

### <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name)

Description: The name of the resource group in which the virtual machine should exist. Changing this forces a new resource to be created.

Type: `string`

### <a name="input_runner_github_pat"></a> [runner\_github\_pat](#input\_runner\_github\_pat)

Description: GitHub PAT that will be used to register GitHub Action Runner tokens

Type: `string`

### <a name="input_runner_github_repo"></a> [runner\_github\_repo](#input\_runner\_github\_repo)

Description: Specify the GitHub repository owner and name seperated by `/` to register the action runner. e.g. `cloudeteer/squad-customer`

Type: `string`

### <a name="input_snet_address_prefixes"></a> [snet\_address\_prefixes](#input\_snet\_address\_prefixes)

Description: A list of IP address prefixes (CIDR blocks) to be assigned to the subnet. Each entry in the list represents a CIDR block used to define the address space of the subnet within the virtual network.

Type: `list(string)`

### <a name="input_vnet_address_space"></a> [vnet\_address\_space](#input\_vnet\_address\_space)

Description: A list of IP address ranges to be assigned to the virtual network (VNet). Each entry in the list represents a CIDR block used to define the address space of the VNet.

Type: `list(string)`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_init"></a> [init](#input\_init)

Description: Is used for initiating the module itself for the first time. For more information please go here https://github.com/cloudeteer/terraform-azurerm-launchpad/blob/main/INSTALL.md

Type: `bool`

Default: `false`

### <a name="input_init_access_azure_principal_id"></a> [init\_access\_azure\_principal\_id](#input\_init\_access\_azure\_principal\_id)

Description: n/a

Type: `string`

Default: `null`

### <a name="input_init_access_ip_address"></a> [init\_access\_ip\_address](#input\_init\_access\_ip\_address)

Description: Set the IP Address of your current public IP in order to access the new created resources. For more information please go here https://github.com/cloudeteer/terraform-azurerm-launchpad/blob/main/INSTALL.md

Type: `string`

Default: `null`

### <a name="input_key_vault_private_dns_zone_ids"></a> [key\_vault\_private\_dns\_zone\_ids](#input\_key\_vault\_private\_dns\_zone\_ids)

Description: A list of ID´s of DNS Zones in order to add the Private Endpoint of the Keyvault into your DNS Zones.

Type: `list(string)`

Default: `[]`

### <a name="input_runner_arch"></a> [runner\_arch](#input\_runner\_arch)

Description: The CPU architecture to run the GitHub actions runner. Can be `x64` or `arm64`.

Type: `string`

Default: `"arm64"`

### <a name="input_runner_count"></a> [runner\_count](#input\_runner\_count)

Description: Specify the number of instances of a GitHub Action runner to install on a single virtual machine instance.

Type: `string`

Default: `"5"`

### <a name="input_runner_public_ip_address"></a> [runner\_public\_ip\_address](#input\_runner\_public\_ip\_address)

Description: Set the value of this variable to `true` if you want to allocate a public IP address to each instance within the Virtual Machine Scale Set. Enabling this option may be necessary to establish internet access when a direct connection to a HUB is currently unavailable.

Type: `bool`

Default: `false`

### <a name="input_runner_user"></a> [runner\_user](#input\_runner\_user)

Description: An unprivileged user to run the Runner application. If this user does not exist on the system, a new user will be created.

Type: `string`

Default: `"actions-runner"`

### <a name="input_runner_version"></a> [runner\_version](#input\_runner\_version)

Description: Set a specific GitHub action runner version (without the `v` in the version string) or use `latest`.

Type: `string`

Default: `"latest"`

### <a name="input_runner_vm_instances"></a> [runner\_vm\_instances](#input\_runner\_vm\_instances)

Description: Set the amount of VM´s in the Virtual Machine Sscale Set (VMSS). (Default '1')

Type: `string`

Default: `1`

### <a name="input_tags"></a> [tags](#input\_tags)

Description: A mapping of tags which should be assigned to all resources in this module.

Type: `map(string)`

Default: `{}`

## Outputs

The following outputs are exported:

### <a name="output_ARM_CLIENT_ID"></a> [ARM\_CLIENT\_ID](#output\_ARM\_CLIENT\_ID)

Description: n/a

### <a name="output_key_vault_name"></a> [key\_vault\_name](#output\_key\_vault\_name)

Description: n/a

### <a name="output_location"></a> [location](#output\_location)

Description: n/a

### <a name="output_subnet_id"></a> [subnet\_id](#output\_subnet\_id)

Description: n/a

### <a name="output_subnet_name"></a> [subnet\_name](#output\_subnet\_name)

Description: n/a

### <a name="output_tfstate_storage_account_name"></a> [tfstate\_storage\_account\_name](#output\_tfstate\_storage\_account\_name)

Description: n/a

### <a name="output_vnet_id"></a> [vnet\_id](#output\_vnet\_id)

Description: n/a

### <a name="output_vnet_name"></a> [vnet\_name](#output\_vnet\_name)

Description: n/a
<!-- END_TF_DOCS -->

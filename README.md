<!-- markdownlint-disable first-line-h1 no-inline-html -->

> [!NOTE]
> This repository is publicly accessible as part of our open-source initiative. We welcome contributions from the community alongside our organization's primary development efforts.

---

# terraform-azurerm-launchpad

[![SemVer](https://img.shields.io/badge/SemVer-2.0.0-blue.svg)](https://github.com/cloudeteer/terraform-azurerm-launchpad/releases)

This module provisions all essential infrastructure components within an Azure tenant to enable secure, automated management using Terraform and GitHub. It sets up a GitHub private runner, a Terraform state storage account, and other key resources necessary for fully automated Terraform deployments. The module is designed to adhere to security best practices throughout the process.
## Design

The IaC Launchpad is a collection of essential Azure resources required for managing Terraform deployments via Cloudeteer GitHub Actions. The term “Launchpad” draws an analogy to rocket science, emphasizing the foundational role it plays.

[![Launchpad Design](images/diagram.svg)](images/diagram.png)

<!-- BEGIN_TF_DOCS -->
## Usage

This example demonstrates the usage of the launch-pad module with default settings. It sets up all necessary dependencies, including a resource group, virtual network, subnet to ensure seamless deployment.

```hcl
resource "azurerm_resource_group" "example" {
  location = "germanywestcentral"
  name     = "example-resource-group"
}

resource "azurerm_virtual_network" "example" {
  name                = "vnet-example-dev-gwc-01"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  address_space = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "example" {
  name                = "snet-example-dev-gwc-01"
  resource_group_name = azurerm_resource_group.example.name

  address_prefixes     = ["10.0.2.0/24"]
  virtual_network_name = azurerm_virtual_network.example.name
}

module "example" {
  source = "cloudeteer/launchpad/azurerm"

  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location

  runner_github_pat  = "github_pat_0000000000000000000000_00000000000000000000000000000000000000000000000000000000000"
  runner_github_repo = "owner/repository"

  virtual_network_address_space = azurerm_virtual_network.example.address_space
  subnet_address_prefixes       = azurerm_subnet.example.address_prefixes
  management_group_names        = ["mg-example"]
}
```

## Providers

The following providers are used by this module:

- <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) (>= 3.114)

- <a name="provider_random"></a> [random](#provider\_random) (>= 3.6)



## Resources

The following resources are used by this module:

- [azurerm_federated_identity_credential.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/federated_identity_credential) (resource)
- [azurerm_key_vault.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault) (resource)
- [azurerm_key_vault_secret.virtual_machine_scale_set_admin_password](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) (resource)
- [azurerm_linux_virtual_machine_scale_set.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine_scale_set) (resource)
- [azurerm_network_security_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group) (resource)
- [azurerm_private_endpoint.key_vault](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) (resource)
- [azurerm_private_endpoint.storage_account](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) (resource)
- [azurerm_role_assignment.key_vault_admin_current_user](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) (resource)
- [azurerm_role_assignment.management_group_owner](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) (resource)
- [azurerm_role_assignment.resource_specific](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) (resource)
- [azurerm_role_assignment.storage_account_blob_owner_current_user](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) (resource)
- [azurerm_role_assignment.subscription_owner](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) (resource)
- [azurerm_storage_account.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account) (resource)
- [azurerm_storage_container.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_container) (resource)
- [azurerm_subnet.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) (resource)
- [azurerm_subnet_network_security_group_association.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_network_security_group_association) (resource)
- [azurerm_user_assigned_identity.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity) (resource)
- [azurerm_virtual_network.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) (resource)
- [random_password.virtual_machine_scale_set_admin_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) (resource)
- [random_string.kvlaunchpadprd_suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) (resource)
- [random_string.stlaunchpadprd_suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) (resource)
- [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) (data source)
- [azurerm_management_group.managed_by_launchpad](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/management_group) (data source)
- [azurerm_subscription.managed_by_launchpad](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) (data source)

## Required Inputs

The following input variables are required:

### <a name="input_location"></a> [location](#input\_location)

Description: The geographic location where the resources will be deployed. This is must be a region name supported by Azure.

Type: `string`

### <a name="input_management_group_names"></a> [management\_group\_names](#input\_management\_group\_names)

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

### <a name="input_subnet_address_prefixes"></a> [subnet\_address\_prefixes](#input\_subnet\_address\_prefixes)

Description: A list of IP address prefixes (CIDR blocks) to be assigned to the subnet. Each entry in the list represents a CIDR block used to define the address space of the subnet within the virtual network.

Type: `list(string)`

### <a name="input_virtual_network_address_space"></a> [virtual\_network\_address\_space](#input\_virtual\_network\_address\_space)

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

### <a name="input_runner_github_environments"></a> [runner\_github\_environments](#input\_runner\_github\_environments)

Description: List of Github environments used by federal identity.

Type: `map(string)`

Default:

```json
{
  "prod-azure": "prod-azure",
  "prod-azure-plan": "prod-azure (plan)"
}
```

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

### <a name="input_subscription_ids"></a> [subscription\_ids](#input\_subscription\_ids)

Description: A list of subscription IDs, which the Launchpad will manage.Each must be exactly 36 characters long.

Type: `list(string)`

Default: `[]`

### <a name="input_tags"></a> [tags](#input\_tags)

Description: A mapping of tags which should be assigned to all resources in this module.

Type: `map(string)`

Default: `{}`

## Outputs

The following outputs are exported:

### <a name="output_LAUNCHPAD_AZURE_CLIENT_ID"></a> [LAUNCHPAD\_AZURE\_CLIENT\_ID](#output\_LAUNCHPAD\_AZURE\_CLIENT\_ID)

Description: The client ID of the Azure user identity assigned to the Launchpad.

### <a name="output_LAUNCHPAD_AZURE_STORAGE_ACCOUNT_NAME"></a> [LAUNCHPAD\_AZURE\_STORAGE\_ACCOUNT\_NAME](#output\_LAUNCHPAD\_AZURE\_STORAGE\_ACCOUNT\_NAME)

Description: The storage account name used by the Launchpad for the Terraform state backend.

### <a name="output_LAUNCHPAD_AZURE_TENANT_ID"></a> [LAUNCHPAD\_AZURE\_TENANT\_ID](#output\_LAUNCHPAD\_AZURE\_TENANT\_ID)

Description: The tenant ID of the Azure user identity assigned to the Launchpad

### <a name="output_subnet_id"></a> [subnet\_id](#output\_subnet\_id)

Description: The ID of the subnet within the Virtual Network, associated with the Launchpad production environment.

### <a name="output_subnet_name"></a> [subnet\_name](#output\_subnet\_name)

Description: The name of the subnet within the Virtual Network, associated with the Launchpad production environment.

### <a name="output_virtual_network_id"></a> [virtual\_network\_id](#output\_virtual\_network\_id)

Description: The ID of the Azure Virtual Network (VNet) associated with the Launchpad.

### <a name="output_virtual_network_name"></a> [virtual\_network\_name](#output\_virtual\_network\_name)

Description: The name of the Azure Virtual Network (VNet) associated with the Launchpad.
<!-- END_TF_DOCS -->

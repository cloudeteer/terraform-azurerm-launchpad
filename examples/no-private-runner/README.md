# Example: No Private Runner

This example demonstrates the usage of the Launchpad without deploying a private runner in the form of a virtual machine managed by a virtual machine scale set. Instead, the default GitHub public runner will be used. In such a deployment, the Launchpad components include the Storage Account, Key Vault (optional), and the Managed Identity with federation to the GitHub Repository from which the Terraform code will be deployed. As a result, the Key Vault and Storage Account need to be publicly accessible.

# Example: Initial Deployment

During the initial deployment of the Launchpad, certain components need to be deployed with relaxed security settings. The Storage Account and Key Vault must be accessible by the user executing `terraform apply`. Additionally, the necessary permissions (`Key Vault Administrator` and `Storage Blob Contributor`) must be granted to that user.

This example demonstrates the input variables required to meet these requirements. Although these variables are defined in code, it is NOT RECOMMENDED to do this in production. Instead, set the input variables via the `-var` argument or with `TF_VAR_` environment variables temporarily. This ensures that on subsequent `terraform apply` executions, preferably done by GitHub Actions workflows, these temporary input variables are not set, and the Launchpad module configures all components with the highest security settings.

Example using `-var`:

```console
$ terraform apply \
  -var=grant_access_to_key_vault=true \
  -var=grant_access_to_storage_account=true \
  -var=storage_account_public_network_access_enabled=true \
  -var=storage_account_public_network_access_ip_rules=["your_public_ip_address"] \
  -var=key_vault_public_network_access_enabled=true \
  -var=key_vault_public_network_access_ip_rules=["your_public_ip_address"]
```

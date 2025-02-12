# mandatory variables
location               = "germanywestcentral"
management_group_names = ["mg-test-1", "mg-test-2"]
resource_group_name    = "rg-test-1"
runner_github_pat      = "github_pat_0000000000000000000000_00000000000000000000000000000000000000000000000000000000000"
runner_github_repo     = "owner/repo"
subscription_ids       = ["00000000-0000-0000-0000-000000000000"]

# semi-mandatory variables, these are mandatory unless specific features are disabled
subnet_address_prefixes       = ["192.168.0.0/24"]
virtual_network_address_space = ["192.168.0.0/24"]

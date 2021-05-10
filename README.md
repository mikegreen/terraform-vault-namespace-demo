# terraform-vault-namespace-demo
Demo to create a namespace in Vault, add policy/secret engine all using Terraform
Feedback and additions welcome. 
Note ~> Namespaces in Vault require Vault Enterprise. 

## Purpose of this repo

Using Terraform and the Vault provider, we want to create a namespace on an existing Vault cluster and add some usual bits to it, like policy, engine for secrets, and auth. 

We'll start with: 

1. Create root-level policy and read-only audit user, `audit_user/changeme` (root-namespace.tf)
1. Create namespaces (main.tf)
1. Define policies to allow a namespace-admin and a secrets-manager persona (modules/bootstrap-namespace/bootstrap_policies.tf)
1. Build up namespaces (modules/bootstrap-namespace/main.tf)
   1. Create namespace
   1. Create admin-policy
   1. Create secrets-manager-policy
   1. Create tokens for each (yes, this isn't good practice but makes testing easier)
   1. Create secrets mounts (based on variable secrets_to_mount)
   1. Create auth mounts (based on variable auths_to_mount)
   1. Create userpass auth and `user1/changeme` login

## Usage

1. Ensure terraform >= 0.13 is in your path
1. Define your Vault address and Vault token in variables, vault_addr and vault_token (either in local.auto.tfvars, or your TFE/TFC variables)
1. `$ terraform plan` and check it out
1. `$ terraform apply` if you like what you see
1. Get the tokens created for each policy in each namespace with: `$ terraform state pull | jq '.resources[] | select(.type == "vault_token") | .instances[0].attributes'` 


Sample local.auth.tfvars
```
vault_addr = "https://yourvault.company.com:8200"
vault_token = "your-token-here"
secrets_to_mount = ["kv","kv-v2","pki","transit"]
auths_to_mount = ["userpass","aws"]
```

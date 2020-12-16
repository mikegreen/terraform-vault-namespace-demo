# terraform-vault-namespace-demo
Demo to create a namespace in Vault, add policy/secret engine all using Terraform
Feedback and additions welcome. 

## Purpose of this repo

Using Terraform and the Vault provider, we want to create a namespace on an existing Vault cluster and add some usual bits to it, like policy, engine for secrets, and auth. 

We'll start with: 

1. Create a namespace 
1. Define and attach a policy that allows root-like access only on the namespace
1. Create a 30hr token with this policy
1. Enable some secret mounts: secrets_to_mount = ["kv","kv-v2","pki","transit"]
1. Enable some auth mounts = ["userpass","aws"]
1. Write a sample KV (which you can read back with `$ vault read namespace01/kv/first-secret`)

## Usage

1. Ensure terraform >= 0.13 is in your path
1. Define your Vault address and Vault token in variables, vault_addr and vault_token (either in local.auto.tfvars, or your TFE/TFC variables)
1. `$ terraform plan` and check it out
1. `$ terraform apply` if you like what you see
1. The output will contain a namespace-token value, which you login to vault with


Sample local.auth.tfvars
```
vault_addr = "https://yourvault.company.com:8200"
vault_token = "your-token-here"
secrets_to_mount = ["kv","kv-v2","pki","transit"]
auths_to_mount = ["userpass","aws"]
```
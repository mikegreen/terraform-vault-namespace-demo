# terraform-vault-namespace-demo
Demo to create a namespace in Vault, add policy/roles/secret engine all using Terraform

## Purpose of this repo

Using Terraform and the Vault provider, we want to create a namespace on an existing Vault cluster and add some usual bits to it, like policy, role and an engine for secrets. 

We'll start with: 

1. Create a namespace with one main.tf
1. Using another (for reasons we'll explain later) main.tf, 
1. Attach a policy
1. Create a role
1. Enable the KV secrets engine at a custom mount point
1. Enable an authentication engine (which? TBD)

## Usage

1. Ensure terraform >= 0.12 is in your path
1. `$ terraform apply -var="namespace=new_namespace_here"`
1. This will create a namespace with your provided variable namespace name, create a policy `example_policy: new_namespace_here`
1. TODO Create role
1. TODO Enable KV engine
1. TODO Enable auth engine

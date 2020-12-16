# main.tf

terraform {
  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = ">= 2.16.0"
    }
  }
}

provider "vault" {
  alias = "vault-root"
  # See above for credential recommendations for environment variables 
  address = var.vault_addr
  token   = var.vault_token
}


## More samples to start with:
# resource "vault_auth_backend" "example" {
#   provider = vault.namespace01
#   type     = "approle"
#   path     = "approleNamespaceDemo"
# }

# resource "vault_approle_auth_backend_role" "example" {
#   backend        = vault_auth_backend.example.path
#   role_name      = "test-role"
#   token_policies = ["example_policy"]
# }

# resource "vault_approle_auth_backend_role_secret_id" "id" {
#   backend   = vault_auth_backend.example.path
#   role_name = vault_approle_auth_backend_role.example.role_name
# }


# module "namespace_bootstrap" {
#   source = "./modules/namespace_bootstrap"

#   namespaces = local.namespaces_to_manage
# }

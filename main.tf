# main.tf

terraform {
  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = ">= 2.16.0"
    }
  }
}

# Define vault provider at root level, so we can create namespaces within
provider "vault" {
  alias = "vault-root"
  address = var.vault_addr
  token   = var.vault_token
}

# Below, you have to repeat each of vault_namespace and namespace_bootstrap module
# for each new namespace. This is because you can't currently pass a map/vars 
# into a provider called from a module. 
# Not very DRY
# Update this to use for_each, when this gets done:
# https://github.com/hashicorp/terraform/issues/24476

# 1st namespace
resource "vault_namespace" "namespace01" {
  provider = vault.vault-root
  path     = "foo01"
}

module "namespace_bootstrap01" {
  source = "./modules/namespace_bootstrap"
  namespace = vault_namespace.namespace01.path
}

# 2nd namespace 
resource "vault_namespace" "namespace02" {
  provider = vault.vault-root
  path     = "foo02"
}

module "namespace_bootstrap02" {
  source = "./modules/namespace_bootstrap"
  namespace = vault_namespace.namespace02.path
}

# # 3rd namespace 
# resource "vault_namespace" "namespace03" {
#   provider = vault.vault-root
#   path     = "foo03"
# }

# module "namespace_bootstrap03" {
#   source = "./modules/namespace_bootstrap"
#   namespace = vault_namespace.namespace03.path
# }


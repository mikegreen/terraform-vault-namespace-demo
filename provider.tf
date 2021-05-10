# provider.tf

terraform {
  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = "~> 2.0"
    }
  }
}

# Vault provider for the "root" non-namespace level, this lets us create a namespace
provider "vault" {
  alias = "vault-root"
  # See above for credential recommendations for environment variables 
  # address = var.vault_addr
  # token   = var.vault_token
}


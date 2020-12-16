# Module to bootstrap a namespace

variable "namespace" {}

provider "vault" {
  // alias = var.namespaces
  # See above for credential recommendations for environment variables 
  # address   = var.vault_addr
  # token     = var.vault_token
  namespace = var.namespace
}

# Create the data for the policy
data "vault_policy_document" "admin_policy_content" {
  rule {
    path         = "/${var.namespace}"
    capabilities = ["create", "read", "update", "delete", "list", "sudo"]
    description  = "allow everything like root token"
  }
}

# Implement the policy
resource "vault_policy" "admin_policy" {
  name   = ("example_policy_${var.namespace}")
  policy = data.vault_policy_document.admin_policy_content.hcl
}

# Create a token with the namespace-only policy
resource "vault_token" "namespace-token" {
  ttl      = "30h"
  policies = [("example_policy_${var.namespace}")]
}

# Make the token an output so we can use it
output "namespace-token" {
  value = vault_token.namespace-token.client_token
# Not sensitive to show on CLI for demo purposes
  # sensitive   = false
}
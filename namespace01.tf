# Clone this .tf file and change namespace01 to your preferred namespace
# It requires hardcoding as you can't use a variable in a provider setting
# Create the namespace

resource "vault_namespace" "namespace01" {
  provider = vault.vault-root
  path     = "namespace01"
}

provider "vault" {
  alias = "namespace01"
  # See above for credential recommendations for environment variables 
  address   = var.vault_addr
  token     = var.vault_token
  namespace = vault_namespace.namespace01.path
}

# Implement the policy
# this policy is defined in bootstrap_policies.tf
resource "vault_policy" "admin_policy" {
  provider = vault.namespace01
  name     = format("namespace-policy")
  policy   = data.vault_policy_document.admin_policy_content.hcl
}

# Create a token with the namespace-only policy
resource "vault_token" "namespace-token" {
  provider = vault.namespace01
  ttl      = "30h"
  policies = ["namespace-policy"]
}

# Make the token an output so we can use it
output "namespace-token" {
  value = vault_token.namespace-token.client_token
}

# Create mounts defined in the variable mounts_to_mount
# if you want to have TF work with manually created/existing:
# $ terraform import vault_mount.all_the_mounts kv-v2 (where kv-v2 is the path)
resource "vault_mount" "all_the_secrets" {
  provider = vault.namespace01
  for_each = toset(var.secrets_to_mount)
  type = each.key
  path = each.key
}

# Create custom secret mount if you wish
# resource "vault_mount" "kv-v1" {
#   provider    = vault.namespace01
#   path        = "kv-v1"
#   type        = "kv"
#   description = "Example KV v1 secrets mount"
# }

# Assuming the kv mount is enabled, add a secret into the KV engine just created
# Note, we might need depends_on because TF does not know if this mount exists yet
resource "vault_generic_secret" "secret" {
  provider = vault.namespace01
  path     = "kv/first-secret"
  depends_on = [
    vault_mount.all_the_secrets,
  ]
  data_json = <<EOT
    {
      "foo":  "bar",
      "pizza": "cheesey"
    }
    EOT
} 

resource "vault_auth_backend" "all_the_auths" {
  provider = vault.namespace01
  for_each = toset(var.auths_to_mount)
  type = each.key
  path = each.key
}
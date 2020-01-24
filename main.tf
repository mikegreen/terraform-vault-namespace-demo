# main.tf
# usage:
# $ terraform apply -var="namespace=new_namespace_here"
#

provider "vault" {
  alias = "v1"
  #  Auth creds below can be set here directly, in the variables file (as shown currently), 
  # or commented out and set as environment variables such as:
  # $ export VAULT_ADDR=http://123.123.123.1:8200
  # $ export VAULT_TOKEN=s.xxxxXXXXxxxxferJCj3Aljm7

  #  address = var.vault_addr
  #  token   = var.vault_token
}

# Create the namespace
resource "vault_namespace" "ns1" {
  provider = vault.v1
  path     = var.namespace
}

provider "vault" {
  alias = "v2"
  # See above for credential recommendations for environment variables 
  #  address   = var.vault_addr
  #  token     = var.vault_token
  namespace = vault_namespace.ns1.path
}

# Create the data for the policy
data "vault_policy_document" "example" {
  provider = vault.v2
  rule {
    path         = "secret/*"
    capabilities = ["create", "read", "update", "delete", "list"]
    description  = "allow all on secrets"
  }
}

# Implement the policy
resource "vault_policy" "example" {
  provider = vault.v2
  name     = format("example_policy_01: %s", var.namespace)
  policy   = data.vault_policy_document.example.hcl
}

resource "vault_auth_backend" "example" {
  provider = vault.v2
  type     = "approle"
  path     = "approleNamespaceDemo"
}

# Create a KV secrets engine mount
resource "vault_mount" "example" {
  provider    = vault.v2
  path        = "secret"
  type        = "kv"
  description = "generic mount"
}

# Add a secret into the KV engine just created
# Note, we need depends_on because TF does not know if this mount exists yet
resource "vault_generic_secret" "secret" {
  provider = vault.v2
  path     = "secret/foo"
  depends_on = [
    vault_mount.example,
  ]
  data_json = <<EOT
    {
      "foo":  "bar",
      "pizza": "cheese"
    }
    EOT
}








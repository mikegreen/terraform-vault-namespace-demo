
provider "vault" {
  alias     = "new"
  namespace = var.new-namespace
}

provider "vault" {
  alias = "vault-root"
}

resource "vault_namespace" "new-namespace" {
  provider = vault.vault-root
  path     = var.new-namespace
}

# Create a token with the admin-namespace-only policy
resource "vault_token" "namespace-admin-token" {
  provider = vault.new
  ttl      = "1h"
  policies = [vault_policy.admin-policy.name]
  depends_on = [
    vault_policy.admin-policy
  ]
}

# Create a token that can only manage secrets 
resource "vault_token" "namespace-secrets-manager-token" {
  provider = vault.new
  ttl      = "8h"
  policies = [vault_policy.secrets-manager-policy.name]
  depends_on = [
    vault_policy.secrets-manager-policy
  ]
}

resource "vault_mount" "all_the_secrets" {
  depends_on = [vault_namespace.new-namespace]
  provider   = vault.new
  for_each   = toset(var.secrets_to_mount)
  type       = each.key
  path       = "${var.path-prefix}-${each.key}"
}

resource "vault_mount" "shared_secrets" {
  depends_on = [vault_namespace.new-namespace]
  provider   = vault.new
  type       = "kv"
  path       = "${var.path-prefix}-shared"
}

resource "vault_auth_backend" "all_the_auths" {
  depends_on = [vault_namespace.new-namespace]
  provider   = vault.new
  for_each   = toset(var.auths_to_mount)
  type       = each.key
  path       = each.key
  tune {
    default_lease_ttl = "6h"
    max_lease_ttl     = "24h"
  }
}

resource "vault_auth_backend" "userpass" {
  depends_on = [vault_namespace.new-namespace]
  provider   = vault.new
  type       = "userpass"
  path       = "userpass"
}

# Add rate limit of 100/sec across namespace to protect noisy neighbor issues
resource "vault_quota_rate_limit" "namespace-wide-quota" {
  depends_on = [vault_namespace.new-namespace]
  # From https://www.vaultproject.io/api/system/rate-limit-quotas#parameters
  name = "${var.new-namespace}-wide-quota"
  path = "${var.new-namespace}/"
  rate = var.namespace-rate-limit
  # provider 2.19.1 does not yet support interval/block_interval
  # see https://github.com/hashicorp/terraform-provider-vault/issues/1049
  # interval = "5s"
  # block_interval = "5s"
}

# # Assuming the kv mount is enabled, add a secret into the KV engine just created
# # Note, we need depends_on because TF does not know if this mount exists yet
# resource "vault_generic_secret" "secret" {
#   provider   = vault.new
#   depends_on = [vault_mount.all_the_secrets]
#   path       = "kv/first-secret"
#   data_json  = <<EOT
#     {
#       "foo":  "bar",
#       "pizza": "cheesey"
#     }
#     EOT
# }


provider "vault" {
  alias     = "new"
  namespace = var.new-namespace
}

provider "vault" {
  alias = "vault-root"
}

# provider "null" {
# }

resource "vault_namespace" "new-namespace" {
  provider = vault.vault-root
  path     = var.new-namespace
}

resource "vault_policy" "admin-policy" {
  depends_on = [vault_namespace.new-namespace]
  provider   = vault.new
  name       = "${var.new-namespace}-admin-policy"
  policy     = data.vault_policy_document.admin_policy_content.hcl
}

resource "vault_policy" "secrets-manager-policy" {
  depends_on = [vault_namespace.new-namespace]
  provider   = vault.new
  name       = "${var.new-namespace}-secrets-manager-policy"
  policy     = data.vault_policy_document.secrets_manager_policy_content.hcl
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

# Make the token an output so we can use it
# In real life, this is a terrible idea so don't do it
# we get these out via
# $ terraform state pull | jq '.resources[] | select(.type == "vault_token") | .instances[0].attributes'
output "namespace-admin-token" {
  value = vault_token.namespace-admin-token.client_token
}

output "namespace-secrets-manager-token" {
  value = vault_token.namespace-secrets-manager-token.client_token
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

# add a bootstrapped user
resource "vault_generic_endpoint" "secrets_manager_user1" {
  provider             = vault.new
  depends_on           = [vault_auth_backend.userpass]
  path                 = "auth/userpass/users/user1"
  ignore_absent_fields = true

  data_json = <<EOT
{
  "policies": ["${var.new-namespace}-secrets-manager-policy"],
  "password": "changeme"
}
EOT
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

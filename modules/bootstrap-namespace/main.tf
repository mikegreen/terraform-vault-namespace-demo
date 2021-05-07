
provider "vault" {
  alias = "new"
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
  depends_on = [
  	vault_namespace.new-namespace
  ]
  provider = vault.new
  name     = "${var.new-namespace}-admin-policy"
  policy   = var.admin-policy-content
}

resource "vault_policy" "secrets-manager-policy" {
  depends_on = [
  	vault_namespace.new-namespace
  ]
  provider = vault.new
  name     = "${var.new-namespace}-secrets-manager-policy"
  policy   = var.secrets-manager-policy-content
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
  ttl      = "30h"
  policies = [vault_policy.secrets-manager-policy.name]
  depends_on = [
    vault_policy.secrets-manager-policy
  ]
}

# Make the token an output so we can use it
# In real life, this is a terrible idea so don't do it
output "namespace-admin-token" {
  value = vault_token.namespace-admin-token.client_token
}

output "namespace-secrets-manager-token" {
  value = vault_token.namespace-secrets-manager-token.client_token
}


resource "vault_mount" "all_the_secrets" {
  provider = vault.new
  for_each = toset(var.secrets_to_mount)
  type     = each.key
  path     = "${var.path-prefix}-${each.key}"
}




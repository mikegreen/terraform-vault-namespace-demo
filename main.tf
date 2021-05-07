

module "namespace01" {
  source = "./modules/bootstrap-namespace/"
  new-namespace = "namespace_new_01"
  providers = {
   // vault.zone = vault.dev1
    vault.vault-root = vault.vault-root
  }
  admin-policy-content   = data.vault_policy_document.admin_policy_content.hcl
  secrets-manager-policy-content   = data.vault_policy_document.secrets_manager_policy_content.hcl
}

module "namespace02" {
  source = "./modules/bootstrap-namespace/"
  new-namespace = "namespace_new_02"
  providers = {
   // vault.zone = vault.dev1
    vault.vault-root = vault.vault-root
  }
  admin-policy-content   = data.vault_policy_document.admin_policy_content.hcl
  secrets-manager-policy-content   = data.vault_policy_document.secrets_manager_policy_content.hcl
}

# examples that you can output a token, 
# ie, 
output "namespace-admin-token" {
  value = module.namespace01.namespace-admin-token
  sensitive = true
}

output "namespace-secrets-manager-token" {
  value = module.namespace01.namespace-secrets-manager-token
  sensitive = true
}
# Make the token an output so we can use it
# In real life, this is a terrible idea so don't do it
# output "namespace-token" {
#   sensitive = true
#   value = vault_token.namespace-token.client_token
# }

# output "namespace-secrets-manager-token" {
#   sensitive = true
#   value = vault_token.namespace-secrets-manager-token.client_token
# }

# Create mounts defined in the variable mounts_to_mount
# if you want to have TF work with manually created/existing:
# $ terraform import vault_mount.all_the_mounts kv-v2 (where kv-v2 is the path)
# resource "vault_mount" "all_the_secrets" {
#   provider = vault.namespace01
#   for_each = toset(var.secrets_to_mount)
#   type     = each.key
#   path     = each.key
#   options = {
#     listing_visibility = "unauth"
#   }
# }

# Create custom secret mount if you wish
# resource "vault_mount" "kv-v1" {
#   provider    = vault.namespace01
#   path        = "kv-v1"
#   type        = "kv"
#   description = "Example KV v1 secrets mount"
# }

# Assuming the kv mount is enabled, add a secret into the KV engine just created
# Note, we might need depends_on because TF does not know if this mount exists yet
# resource "vault_generic_secret" "secret" {
#   provider = vault.namespace01
#   path     = "kv/first-secret"
#   depends_on = [
#     vault_mount.all_the_secrets,
#   ]
#   data_json = <<EOT
#     {
#       "foo":  "bar",
#       "pizza": "cheesey"
#     }
#     EOT
# }

# resource "vault_auth_backend" "all_the_auths" {
#   provider = vault.namespace01
#   for_each = toset(var.auths_to_mount)
#   type     = each.key
#   path     = each.key
# }

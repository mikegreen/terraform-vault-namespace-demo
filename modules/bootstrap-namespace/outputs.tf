# outputs.tf

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

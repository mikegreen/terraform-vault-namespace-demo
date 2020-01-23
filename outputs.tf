# outputs.tf 

output "vault_namespace_id" {
  value = [vault_namespace.ns1.namespace_id]
}

output "vault_namespace_path" {
  value = [vault_namespace.ns1.path]
}

output "vault_policy_name" {
  value = [vault_policy.example.name]
}

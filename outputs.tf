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

output "vault_auth_backend_path" {
  value = [vault_auth_backend.example.path]
}

output "vault_approle_role" {
  value = [vault_approle_auth_backend_role.example.role_name]
}

output "vault_approle_role_id" {
  value = [vault_approle_auth_backend_role.example.role_id]
}

output "vault_approle_secret_id" {
  value = [vault_approle_auth_backend_role_secret_id.id.secret_id]
}

output "vault_mount_path" {
  value = [vault_mount.example.path]
}

output "vault_generic_secret_path" {
  value = [vault_generic_secret.secret.path]
}


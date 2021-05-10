# userpass-users.tf

# add admin user only if we allow sub-namespaces, if not, we create a limited admin user below
resource "vault_generic_endpoint" "admin_user" {
  count                = var.allow-subnamespaces ? 1 : 0
  provider             = vault.new
  depends_on           = [vault_auth_backend.userpass]
  path                 = "auth/userpass/users/admin_user"
  ignore_absent_fields = true

  data_json = <<EOT
{
  "policies": ["${var.new-namespace}-admin-policy"],
  "password": "changeme"
}
EOT
}

# add admin user without namespace mgmt permission, if we don't allow subnamespaces 
# this simply adds the deny policy to sys/namespaces
resource "vault_generic_endpoint" "admin_user_no_ns" {
  count                = var.allow-subnamespaces ? 0 : 1
  provider             = vault.new
  depends_on           = [vault_auth_backend.userpass]
  path                 = "auth/userpass/users/admin_user_no_ns"
  ignore_absent_fields = true

  data_json = <<EOT
{
  "policies": ["${var.new-namespace}-admin-policy","${var.new-namespace}-deny-ns-mgmt-policy"],
  "password": "changeme"
}
EOT
}

# add secrets only user
resource "vault_generic_endpoint" "secrets_manager_user" {
  provider             = vault.new
  depends_on           = [vault_auth_backend.userpass]
  path                 = "auth/userpass/users/secrets_user"
  ignore_absent_fields = true

  data_json = <<EOT
{
  "policies": ["${var.new-namespace}-secrets-manager-policy"],
  "password": "changeme"
}
EOT
}

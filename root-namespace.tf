# root-namespace.tf


resource "vault_policy" "audit-policy" {
  provider = vault.vault-root
  name     = "audit-policy"
  policy   = data.vault_policy_document.audit_policy_content.hcl
}

resource "vault_policy" "infosec-audit-policy" {
  provider = vault.vault-root
  name     = "infosec-audit-policy"
  policy   = data.vault_policy_document.infosec_auditor_policy_content.hcl
}

resource "vault_auth_backend" "userpass" {
  provider = vault.vault-root
  type     = "userpass"
  path     = "userpass_audit"
  tune {
    listing_visibility = "unauth"
  }
}

# add a bootstrapped user
resource "vault_generic_endpoint" "audit_user" {
  provider             = vault.vault-root
  path                 = "auth/userpass_audit/users/audit_user"
  ignore_absent_fields = true

  data_json = <<EOT
{
  "policies": ["${vault_policy.audit-policy.name}"],
  "password": "changeme"
}
EOT
}

# add a bootstrapped user
resource "vault_generic_endpoint" "infosec_audit_user" {
  provider             = vault.vault-root
  path                 = "auth/userpass_audit/users/infosec_audit_user"
  ignore_absent_fields = true

  data_json = <<EOT
{
  "policies": ["${vault_policy.infosec-audit-policy.name}"],
  "password": "changeme"
}
EOT
}



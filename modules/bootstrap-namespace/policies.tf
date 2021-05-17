# policies.tf

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

resource "vault_policy" "deny-ns-mgmt-policy" {
  depends_on = [vault_namespace.new-namespace]
  provider   = vault.new
  name       = "${var.new-namespace}-deny-ns-mgmt-policy"
  policy     = data.vault_policy_document.deny_ns_policy_content.hcl
}


# Module to bootstrap a namespace

variable "namespaces" {}

resource "vault_namespace" "namespace" {
  for_each = var.namespaces
  path     = each.key
}

# Create the data for the policy
data "vault_policy_document" "admin_policy_content" {
  for_each = var.namespaces

  rule {
    // iterate thru the namespace list and create a policy for each namespace's root
    path         = "/${each.key}"
    capabilities = ["create", "read", "update", "delete", "list", "sudo"]
    description  = "allow everything, admin like"
  }
}

# Implement the policy
resource "vault_policy" "admin_policy" {
  // provider = vault.ns01

  for_each = data.vault_policy_document.admin_policy_content
  //name     = format("example_policy")
  name   = ("example_policy_foo ${[each.key]}")
  policy = data.vault_policy_document.admin_policy_content[each.key].hcl
}


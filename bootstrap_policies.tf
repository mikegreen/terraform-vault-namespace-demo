# # Create the data for the policy
data "vault_policy_document" "admin_policy_content" {
  rule {
    path         = "*"
    capabilities = ["create", "read", "update", "delete", "list", "sudo"]
    description  = "allow everything, admin like"
  }
}

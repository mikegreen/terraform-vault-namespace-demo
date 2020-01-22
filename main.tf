provider “vault” {
  # It is strongly recommended to configure this provider through the
  # environment variables described above, so that each user can have
  # separate credentials set in the environment.
  #
  # This will default to using $VAULT_ADDR
  # But can be set explicitly
  # address = “https://vault.example.net:8200”
        address = “http://todo_move_to_var:8200”
        token = “todo_move_to_var”
}
# Create the namespace
resource “vault_namespace” “ns1" {
        path = “ns1”
}

# Create the data for the policy
data “vault_policy_document” “example” {
  rule {
    path         = “secret/*”
    capabilities = [“create”, “read”, “update”, “delete”, “list”]
    description  = “allow all on secrets”
  }
}
# Implement the policy
resource “vault_policy” “example” {
  name   = “example_policy”
  policy = “${data.vault_policy_document.example.hcl}”
}

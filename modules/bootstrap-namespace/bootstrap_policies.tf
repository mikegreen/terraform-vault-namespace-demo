# Create the data for the policy
data "vault_policy_document" "admin_policy_content" {
  rule {
    path         = "*"
    capabilities = ["create", "read", "update", "delete", "list", "sudo"]
    description  = "Policy that allows everything. When given to a token in a namespace, will be like a namespace-root token"
  }
}

# Deny namespace mgmt policy
data "vault_policy_document" "deny_ns_policy_content" {
  rule {
    path         = "sys/namespaces/*"
    capabilities = ["deny"]
    description  = "Policy to prevent namespace management"
  }
}

# Policy to allow secrets access
data "vault_policy_document" "secrets_manager_policy_content" {
  rule {
    path         = "sys/mounts/*"
    capabilities = ["create", "read", "update", "delete", "list", "sudo"]
    description  = "Manage all secret mounts"
  }
  rule {
    path         = "sys/mounts"
    capabilities = ["read", "list"]
    description  = "Read all secret mounts"
  }
  # setup the default secret engines that we have defaulted in the variables
  rule {
    path         = "${var.path-prefix}-kv/*"
    capabilities = ["create", "read", "update", "delete", "list"]
    description  = ""
  }
  rule {
    path         = "${var.path-prefix}-kv-v2/*"
    capabilities = ["create", "read", "update", "delete", "list"]
    description  = ""
  }
  rule {
    path         = "${var.path-prefix}-pki/*"
    capabilities = ["create", "read", "update", "delete", "list"]
    description  = ""
  }
  rule {
    path         = "${var.path-prefix}-transit/*"
    capabilities = ["create", "read", "update", "delete", "list"]
    description  = ""
  }
}



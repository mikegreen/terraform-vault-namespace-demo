# # Create the data for the policy
data "vault_policy_document" "admin_policy_content" {
  rule {
    path         = "*"
    capabilities = ["create", "read", "update", "delete", "list", "sudo"]
    description  = "Policy that allows everything. When given to a token in a namespace, will be like a namespace-root token"
  }
}

# Policy to allow only 
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
    path         = "kv"
    capabilities = ["create", "read", "update", "delete", "list"]
    description  = ""
  }
  rule {
    path         = "kv-v2"
    capabilities = ["create", "read", "update", "delete", "list"]
    description  = ""
  }
  rule {
    path         = "pki"
    capabilities = ["create", "read", "update", "delete", "list"]
    description  = ""
  }
  rule {
    path         = "transit"
    capabilities = ["create", "read", "update", "delete", "list"]
    description  = ""
  }    
}



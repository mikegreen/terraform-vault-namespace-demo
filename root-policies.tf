# root-policies.tf

# Create the data for the policy
data "vault_policy_document" "audit_policy_content" {
  rule {
    path         = "*"
    capabilities = ["read", "list"]
    description  = "Policy that allows read on everything."
  }
}

# Policy to allow general read access for info security / auditor type role
data "vault_policy_document" "infosec_auditor_policy_content" {
  rule {
    path         = "secrets/*"
    capabilities = ["list"]
    description  = "List secrets"
  }
  rule {
    path         = "+/secrets/*"
    capabilities = ["list"]
    description  = "List secrets in tenant namespaces"
  }
  rule {
    path         = "sys/license"
    capabilities = ["list", "read"]
    description  = "List license"
  }
  rule {
    path         = "auth/*"
    capabilities = ["list", "read"]
    description  = "Read all mounted auth methods"
  }
  rule {
    path         = "sys/*"
    capabilities = ["list", "read"]
    description  = "Read all system backend endpoints"
  }
  rule {
    path         = "+/auth/*"
    capabilities = ["list", "read"]
    description  = "Read all mounted auth methods in tenant namespaces"
  }
  rule {
    path         = "+/sys/*"
    capabilities = ["list", "read"]
    description  = "Read all mounted system backend endpoints in tenant namespaces"
  }
  rule {
    path         = "/sys/policies/*"
    capabilities = ["list", "read"]
    description  = "Read all policies"
  }
  rule {
    path         = "+/sys/policies/*"
    capabilities = ["list", "read"]
    description  = "Read all policies in tenant namespaces"
  }
  rule {
    path         = "/sys/internal/ui/mounts"
    capabilities = ["read", "list"]
    description  = "Read special mount for UI"
  }
  rule {
    path         = "+/bootstrapped*"
    capabilities = ["list", ]
    description  = "List on usual tenant namespace secrets"
  }
  rule {
    path         = "+/sys/capabilities-self"
    capabilities = ["create", "read", "update", "list"]
    description  = "Read special mount in tenant namespace, https://www.vaultproject.io/api/system/capabilities-self"
  }
}



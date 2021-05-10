# main.tf

# to add a new namespace, copy an existing module and give it a new-namespace and namespace## increment

module "namespace01" {
  source        = "./modules/bootstrap-namespace/"
  new-namespace = "CloudOps"
  # we default to not allowing a new namespace to have namespaces under, 
  # this is due to the preference in a flat namespace architecture 
  # allow-subnamespaces = false
  providers = {
    // vault.zone = vault.dev1
    vault.vault-root = vault.vault-root
  }
}

module "namespace02" {
  source              = "./modules/bootstrap-namespace/"
  new-namespace       = "FinanceTeam"
  allow-subnamespaces = false
  providers = {
    // vault.zone = vault.dev1
    vault.vault-root = vault.vault-root
  }
}

module "namespace03" {
  source              = "./modules/bootstrap-namespace/"
  new-namespace       = "ColoDataceterTeam"
  allow-subnamespaces = true
  providers = {
    // vault.zone = vault.dev1
    vault.vault-root = vault.vault-root
  }
}


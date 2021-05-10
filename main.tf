# main.tf

# to add a new namespace, copy an existing module and give it a new-namespace and namespace## increment

module "namespace01" {
  source        = "./modules/bootstrap-namespace/"
  new-namespace = "CloudOps"
  providers = {
    // vault.zone = vault.dev1
    vault.vault-root = vault.vault-root
  }
}

module "namespace02" {
  source        = "./modules/bootstrap-namespace/"
  new-namespace = "FinanceTeam"
  providers = {
    // vault.zone = vault.dev1
    vault.vault-root = vault.vault-root
  }
}

module "namespace03" {
  source        = "./modules/bootstrap-namespace/"
  new-namespace = "ColoDataceterTeam"
  providers = {
    // vault.zone = vault.dev1
    vault.vault-root = vault.vault-root
  }
}


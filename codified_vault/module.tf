module "pki" {
  source                                            = "./pki"
  vault_mono_vault_addr                             = local.vault_mono_vault_addr
  VAULT_MONO_LOCAL_FILE_ROOT_CA_NO_PASS_PRIVATE_KEY = var.VAULT_MONO_LOCAL_FILE_ROOT_CA_NO_PASS_PRIVATE_KEY
  VAULT_MONO_LOCAL_FILE_ROOT_CA_CERTIFICATE         = var.VAULT_MONO_LOCAL_FILE_ROOT_CA_CERTIFICATE
  providers = {
    vault = vault
  }

}

module "policy" {
  source = "./policy"
  providers = {
    vault = vault
  }
}

module "auth" {
  source = "./auth"
  providers = {
    vault = vault
  }
  vault_mono_vault_addr = local.vault_mono_vault_addr
  ADMIN_POLICY_NAME     = module.policy.admin
  SCM_CICD_POLICY_NAME  = module.policy.scm_cicd
}

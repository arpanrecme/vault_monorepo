module "managed_pki" {
  source = "./managed_pki"

  providers = {
    vault = vault
  }

  vault_mono_vault_addr                             = local.vault_mono_vault_addr
  VAULT_MONO_LOCAL_FILE_ROOT_CA_NO_PASS_PRIVATE_KEY = var.VAULT_MONO_LOCAL_FILE_ROOT_CA_NO_PASS_PRIVATE_KEY
  VAULT_MONO_LOCAL_FILE_ROOT_CA_CERTIFICATE         = var.VAULT_MONO_LOCAL_FILE_ROOT_CA_CERTIFICATE
}

locals {

  vault_mono_global_config = jsondecode(file(var.VAULT_MONO_LOCAL_FILE_GLOBAL_CONFIG))

  vault_mono_vault_addr = format("%s://%s:%s", local.vault_mono_global_config.VAULT.PROTOCOL,
    local.vault_mono_global_config.VAULT.FQDN,
  local.vault_mono_global_config.VAULT.PORT)

}

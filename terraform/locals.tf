locals {

  vault_mono_global_config = jsondecode(file(var.VAULT_MONO_LOCAL_FILE_GLOBAL_CONFIG))

  vault_mono_vault_addr = format("https://%s:%s",
    local.vault_mono_global_config.VAULT_ADDR_DOMAIN_NAME,
  local.vault_mono_global_config.VAULT_ADDR_PORT)

}

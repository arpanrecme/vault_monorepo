locals {

  vault_mono_global_config = jsondecode(file(var.vault_mono_local_file_global_config))

  vault_mono_vault_addr = format("https://%s:%s",
    local.vault_mono_global_config.VAULT_ADDR_DOMAIN_NAME,
  local.vault_mono_global_config.VAULT_ADDR_PORT)

}

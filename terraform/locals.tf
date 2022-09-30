locals {

  vault_mono_global_config = jsondecode(file(var.vault_mono_local_file_global_config))

  vault_mono_vault_addr = format("https://%s:%s",
    local.vault_mono_global_config.VAULT_ADDR_DOMAIN_NAME,
  local.vault_mono_global_config.VAULT_ADDR_PORT)

  vault_mono_vault_init_secrets = jsondecode(file(var.vault_mono_local_file_vault_init_secrets))

  vault_mono_vault_root_token = local.vault_mono_vault_init_secrets.root_token

}

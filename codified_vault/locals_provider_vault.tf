data "http" "global_config" {
  url = var.VAULT_MONO_GLOBAL_CONFIG_ENDPOINT
  # Optional request headers
  request_headers = {
    Content-Type = "application/json"
  }
}

locals {
  vault_mono_global_config = jsondecode(data.http.global_config.response_body)

  vault_mono_global_config_vault_fqdn = local.vault_mono_global_config.VAULT.FQDN

  vault_mono_global_config_vault_addr = format("%s://%s:%s",
    local.vault_mono_global_config.VAULT.PROTOCOL,
    local.vault_mono_global_config_vault_fqdn,
  local.vault_mono_global_config.VAULT.PORT)

  vault_mono_global_config_root_ca_certificate = local.vault_mono_global_config.ROOT_CA.CERTIFICATE

}

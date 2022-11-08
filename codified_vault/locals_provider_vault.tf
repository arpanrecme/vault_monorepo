data "http" "global_config" {
  url = var.VAULT_MONO_ENDPOINT_GLOBAL_CONFIG
  # Optional request headers
  request_headers = {
    Content-Type = "application/json"
  }
}

locals {
  vault_mono_global_config = jsondecode(data.http.global_config.response_body)
  vault_mono_vault_addr = format("%s://%s:%s",
    local.vault_mono_global_config.VAULT.PROTOCOL,
    local.vault_mono_global_config.VAULT.FQDN,
  local.vault_mono_global_config.VAULT.PORT)

}

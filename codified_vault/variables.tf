variable "VAULT_MONO_ENDPOINT_GLOBAL_CONFIG" {
  type    = string
  default = "https://raw.githubusercontent.com/arpanrecme/vault_monorepo/main/globalconfig.json"
  validation {
    condition     = length(var.VAULT_MONO_ENDPOINT_GLOBAL_CONFIG) > 1
    error_message = "Missing global config file path"
  }
}

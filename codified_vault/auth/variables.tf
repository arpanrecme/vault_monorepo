variable "vault_mono_global_config_vault_addr" {
  type    = string
  default = null
  validation {
    condition     = length(var.vault_mono_global_config_vault_addr) > 1
    error_message = "missing vault address"
  }
}

variable "VAULT_MONO_PREREQUISITE_LOCAL_FILE_AUTH0_CLIENT_DETAILS" {
  type      = string
  default   = null
  sensitive = true
  validation {
    condition     = length(var.VAULT_MONO_PREREQUISITE_LOCAL_FILE_AUTH0_CLIENT_DETAILS) > 1
    error_message = "missing auth0 client application details"
  }
}

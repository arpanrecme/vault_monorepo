variable "vault_mono_vault_addr" {
  type    = string
  default = null
  validation {
    condition     = length(var.vault_mono_vault_addr) > 1
    error_message = "missing vault address"
  }
}

variable "VAULT_MONO_LOCAL_FILE_ROOT_CA_NO_PASS_PRIVATE_KEY" {
  type      = string
  default   = null
  sensitive = true
  validation {
    condition     = length(var.VAULT_MONO_LOCAL_FILE_ROOT_CA_NO_PASS_PRIVATE_KEY) > 1
    error_message = "Missing Root CA Private key file path"
  }
}

variable "VAULT_MONO_LOCAL_FILE_ROOT_CA_CERTIFICATE" {
  type    = string
  default = null
  validation {
    condition     = length(var.VAULT_MONO_LOCAL_FILE_ROOT_CA_CERTIFICATE) > 1
    error_message = "Missing root CA certificate file path"
  }
}

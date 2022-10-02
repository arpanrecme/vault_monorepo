variable "vault_mono_local_file_global_config" {
  type    = string
  default = null
  validation {
    condition     = length(var.vault_mono_local_file_global_config) > 1
    error_message = "Missing global config file path"
  }
}

variable "vault_mono_vault_root_token" {
  type      = string
  default   = null
  sensitive = true
  validation {
    condition     = length(var.vault_mono_vault_root_token) > 1
    error_message = "Missing vault root token"
  }
}

variable "vault_mono_local_file_root_ca_certificate" {
  type    = string
  default = null
  validation {
    condition     = length(var.vault_mono_local_file_root_ca_certificate) > 1
    error_message = "Missing root CA certificate file path"
  }
}

variable "vault_mono_local_file_client_private_key" {
  type    = string
  default = null
  validation {
    condition     = length(var.vault_mono_local_file_client_private_key) > 1
    error_message = "Missing vault mutual TLS auth private key file path"
  }
}

variable "vault_mono_local_file_client_certificate" {
  type    = string
  default = null
  validation {
    condition     = length(var.vault_mono_local_file_client_certificate) > 1
    error_message = "Missing vault mutual TLS auth client certificate file path"
  }
}

variable "VAULT_MONO_GLOBAL_CONFIG_ENDPOINT" {
  type    = string
  default = "https://raw.githubusercontent.com/arpanrecme/dotfiles/main/.config/global.json"
  validation {
    condition     = length(var.VAULT_MONO_GLOBAL_CONFIG_ENDPOINT) > 1
    error_message = "Missing global config file path"
  }
}

variable "VAULT_MONO_LOCAL_FILE_ROOT_CA_CERTIFICATE" {
  type    = string
  default = "../.tmp/mutual_tls_certs/vault_client_cert_chain.pem"
  validation {
    condition     = length(var.VAULT_MONO_LOCAL_FILE_ROOT_CA_CERTIFICATE) > 1
    error_message = "Missing global config file path"
  }
}

variable "VAULT_MONO_VAULT_ROOT_TOKEN" {
  type      = string
  default   = null
  sensitive = true
  validation {
    condition     = length(var.VAULT_MONO_VAULT_ROOT_TOKEN) > 1
    error_message = "Missing vault root token"
  }
}

variable "VAULT_MONO_LOCAL_FILE_CLIENT_PRIVATE_KEY" {
  type      = string
  default   = "../.tmp/mutual_tls_certs/vault_client_key.pem"
  sensitive = true
  validation {
    condition     = length(var.VAULT_MONO_LOCAL_FILE_CLIENT_PRIVATE_KEY) > 1
    error_message = "Missing vault mutual TLS auth private key file path"
  }
}

variable "VAULT_MONO_LOCAL_FILE_CLIENT_CHAIN_CERTIFICATE" {
  type    = string
  default = "../.tmp/mutual_tls_certs/vault_client_cert_chain.pem"
  validation {
    condition     = length(var.VAULT_MONO_LOCAL_FILE_CLIENT_CHAIN_CERTIFICATE) > 1
    error_message = "Missing vault mutual TLS auth client certificate file path"
  }
}

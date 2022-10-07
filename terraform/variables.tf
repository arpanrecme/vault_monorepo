variable "VAULT_MONO_LOCAL_FILE_GLOBAL_CONFIG" {
  type    = string
  default = "../files/config.json"
  validation {
    condition     = length(var.VAULT_MONO_LOCAL_FILE_GLOBAL_CONFIG) > 1
    error_message = "Missing global config file path"
  }
}

variable "VAULT_MONO_VAULT_ROOT_TOKEN" {
  type      = string
  default   = null
  sensitive = true
  validation {
    condition     = length(var.VAULT_MONO_VAULT_ROOT_TOKEN) > 1
    error_message = "Missing vault root token"
  }
}

variable "VAULT_MONO_LOCAL_FILE_ROOT_CA_CERTIFICATE" {
  type    = string
  default = "../files/prerequisite.root_ca_certificate.crt"
  validation {
    condition     = length(var.VAULT_MONO_LOCAL_FILE_ROOT_CA_CERTIFICATE) > 1
    error_message = "Missing root CA certificate file path"
  }
}

variable "VAULT_MONO_LOCAL_FILE_CLIENT_PRIVATE_KEY" {
  type    = string
  default = "../files/secrets.client_private_key.key"
  validation {
    condition     = length(var.VAULT_MONO_LOCAL_FILE_CLIENT_PRIVATE_KEY) > 1
    error_message = "Missing vault mutual TLS auth private key file path"
  }
}

variable "VAULT_MONO_LOCAL_FILE_CLIENT_CERTIFICATE" {
  type    = string
  default = "../files/client_certificate_chain.crt"
  validation {
    condition     = length(var.VAULT_MONO_LOCAL_FILE_CLIENT_CERTIFICATE) > 1
    error_message = "Missing vault mutual TLS auth client certificate file path"
  }
}

variable "VAULT_MONO_LOCAL_FILE_OPENPGP_MASTER_PUBLIC_KEY" {
  type    = string
  default = "../files/prerequisite.openpgp_master_rsa_id.key.pub"
  validation {
    condition     = length(var.VAULT_MONO_LOCAL_FILE_OPENPGP_MASTER_PUBLIC_KEY) > 1
    error_message = "Missing master OPENPGP public key file path"
  }
}

variable "VAULT_MONO_LOCAL_FILE_OPENSSH_MASTER_PUBLIC_KEY" {
  type    = string
  default = "../files/prerequisite.openpgp_master_rsa_id.key.pub"
  validation {
    condition     = length(var.VAULT_MONO_LOCAL_FILE_OPENSSH_MASTER_PUBLIC_KEY) > 1
    error_message = "Missing master OPENSSH public key file path"
  }
}

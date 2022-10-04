variable "VAULT_MONO_LOCAL_FILE_OPENSSH_PRIVATE_KEY" {
  type    = string
  default = null
  validation {
    condition     = length(var.VAULT_MONO_LOCAL_FILE_OPENSSH_PRIVATE_KEY) > 1
    error_message = "Missing OPEN SSH Private Key file path"
  }
}

variable "VAULT_MONO_LOCAL_FILE_OPENSSH_PASSPHRASE_PRIVATE_KEY" {
  type    = string
  default = null
  validation {
    condition     = length(var.VAULT_MONO_LOCAL_FILE_OPENSSH_PASSPHRASE_PRIVATE_KEY) > 1
    error_message = "Missing OPEN SSH Private Key password file path"
  }
}

variable "VAULT_MONO_LOCAL_FILE_OPENSSH_PUBLIC_KEY" {
  type    = string
  default = null
  validation {
    condition     = length(var.VAULT_MONO_LOCAL_FILE_OPENSSH_PUBLIC_KEY) > 1
    error_message = "Missing OPEN SSH Public Key file path"
  }
}

variable "VAULT_MONO_LOCAL_FILE_OPENPGP_PRIVATE_KEY" {
  type    = string
  default = null
  validation {
    condition     = length(var.VAULT_MONO_LOCAL_FILE_OPENPGP_PRIVATE_KEY) > 1
    error_message = "Missing OPEN PGP Private Key file path"
  }
}

variable "VAULT_MONO_LOCAL_FILE_OPENPGP_PASSPHRASE_PRIVATE_KEY" {
  type    = string
  default = null
  validation {
    condition     = length(var.VAULT_MONO_LOCAL_FILE_OPENPGP_PASSPHRASE_PRIVATE_KEY) > 1
    error_message = "Missing OPEN PGP Private Key password file path"
  }
}

variable "VAULT_MONO_LOCAL_FILE_OPENPGP_PUBLIC_KEY" {
  type    = string
  default = null
  validation {
    condition     = length(var.VAULT_MONO_LOCAL_FILE_OPENPGP_PUBLIC_KEY) > 1
    error_message = "Missing OPEN PGP Public Key file path"
  }
}

variable "VAULT_MONO_LOCAL_FILE_LINODE_CLI_PROD_TOKEN" {
  type    = string
  default = null
  validation {
    condition     = length(var.VAULT_MONO_LOCAL_FILE_LINODE_CLI_PROD_TOKEN) > 1
    error_message = "Missing Linode Key file path"
  }
}

variable "VAULT_MONO_LOCAL_FILE_ROOT_CA_PASSPHRASE_PRIVATE_KEY" {
  type    = string
  default = null
  validation {
    condition     = length(var.VAULT_MONO_LOCAL_FILE_ROOT_CA_PASSPHRASE_PRIVATE_KEY) > 1
    error_message = "Missing Root CA Private key password file path"
  }
}

variable "VAULT_MONO_LOCAL_FILE_ROOT_CA_PRIVATE_KEY" {
  type    = string
  default = null
  validation {
    condition     = length(var.VAULT_MONO_LOCAL_FILE_ROOT_CA_PRIVATE_KEY) > 1
    error_message = "Missing Root CA Private key file path"
  }
}

# variable "VAULT_MONO_LOCAL_FILE_ROOT_CA_CERTIFICATE" {
#   type    = string
#   default = null
#   validation {
#     condition     = length(var.VAULT_MONO_LOCAL_FILE_ROOT_CA_CERTIFICATE) > 1
#     error_message = "Missing Root CA Certificate key file path"
#   }
# }

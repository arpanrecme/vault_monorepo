terraform {
  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = "3.9.1"
    }
  }
}

provider "vault" {
  address      = local.vault_mono_vault_addr
  token        = var.VAULT_MONO_VAULT_ROOT_TOKEN
  ca_cert_file = var.VAULT_MONO_LOCAL_FILE_CLIENT_CHAIN_CERTIFICATE
  client_auth {
    cert_file = var.VAULT_MONO_LOCAL_FILE_CLIENT_CHAIN_CERTIFICATE
    key_file  = var.VAULT_MONO_LOCAL_FILE_CLIENT_PRIVATE_KEY
  }
}

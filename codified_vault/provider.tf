terraform {
  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = "3.9.1"
    }
    http = {
      source  = "hashicorp/http"
      version = "3.1.0"
    }
  }
}

provider "vault" {
  address          = local.vault_mono_global_config_vault_addr
  token            = var.VAULT_MONO_VAULT_ROOT_TOKEN
  ca_cert_file     = var.VAULT_MONO_LOCAL_FILE_ROOT_CA_CERTIFICATE
  skip_child_token = false
  skip_tls_verify  = false
  token_name       = "codified_vault"
  client_auth {
    cert_file = var.VAULT_MONO_LOCAL_FILE_CLIENT_CHAIN_CERTIFICATE
    key_file  = var.VAULT_MONO_LOCAL_FILE_CLIENT_PRIVATE_KEY
  }
}

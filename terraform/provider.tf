terraform {
  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = "3.8.2"
    }
  }
}

provider "vault" {
  address      = local.vault_mono_vault_addr
  token        = var.vault_mono_vault_root_token
  ca_cert_file = var.vault_mono_local_file_root_certificate
  client_auth {
    cert_file = var.vault_mono_local_file_client_certificate
    key_file  = var.vault_mono_local_file_client_private_key
  }
}

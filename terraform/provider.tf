terraform {
  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = "3.9.1"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "4.0.3"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.4.3"
    }
  }
}

provider "vault" {
  address      = local.vault_mono_vault_addr
  token        = var.VAULT_MONO_VAULT_ROOT_TOKEN
  ca_cert_file = var.VAULT_MONO_LOCAL_FILE_ROOT_CA_CERTIFICATE
  client_auth {
    cert_file = var.VAULT_MONO_LOCAL_FILE_CLIENT_CERTIFICATE
    key_file  = var.VAULT_MONO_LOCAL_FILE_CLIENT_PRIVATE_KEY
  }
}

provider "tls" {
}

provider "random" {
}

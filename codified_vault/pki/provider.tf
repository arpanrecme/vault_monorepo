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
  }
}

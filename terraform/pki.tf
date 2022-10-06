resource "vault_mount" "pki" {
  type                      = "pki"
  path                      = "pki"
  description               = "Arpanrec Vault CA V1"
  default_lease_ttl_seconds = (90 * 24 * 3600)  # 3 months
  max_lease_ttl_seconds     = (365 * 24 * 3600) # 1 year
}

resource "vault_pki_secret_backend_config_urls" "config_urls" {
  backend                 = vault_mount.pki.path
  issuing_certificates    = [format("%s%s", local.vault_mono_vault_addr, "/v1/pki/ca")]
  crl_distribution_points = [format("%s%s", local.vault_mono_vault_addr, "/v1/pki/crl")]
}

resource "vault_pki_secret_backend_crl_config" "crl_config" {
  backend = vault_mount.pki.path
  expiry  = "72h"
  disable = false
}

resource "tls_private_key" "root_ca" {
  algorithm   = "RSA"
  ecdsa_curve = "P384"
  rsa_bits    = 4096
}

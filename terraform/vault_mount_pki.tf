resource "vault_mount" "pki" {
  type                      = "pki"
  path                      = "pki"
  description               = "Arpanrec Vault CA V1"
  default_lease_ttl_seconds = (90 * 24 * 3600)       # 3 months
  max_lease_ttl_seconds     = (365 * 10 * 24 * 3600) # 10 year
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

resource "vault_pki_secret_backend_intermediate_cert_request" "pki_csr" {
  depends_on  = [vault_mount.pki]
  backend     = vault_mount.pki.path
  type        = "internal"
  common_name = "Arpan Vault Intermittent CA V1"
  alt_names   = ["*.arpanrec.com", "arpanrec.com"]
}

resource "tls_locally_signed_cert" "pki_intermediate_cert" {
  depends_on         = [vault_pki_secret_backend_intermediate_cert_request.pki_csr]
  cert_request_pem   = vault_pki_secret_backend_intermediate_cert_request.pki_csr.csr
  ca_private_key_pem = file(var.VAULT_MONO_LOCAL_FILE_ROOT_CA_PRIVATE_KEY)
  ca_cert_pem        = file(var.VAULT_MONO_LOCAL_FILE_ROOT_CA_CERTIFICATE)

  validity_period_hours = (365 * 24) # 1 year
  is_ca_certificate     = true
  set_subject_key_id    = true
  allowed_uses = [
    "any_extended",
    "cert_signing",
    "client_auth",
    "code_signing",
    "content_commitment",
    "crl_signing",
    "data_encipherment",
    "decipher_only",
    "digital_signature",
    "email_protection",
    "encipher_only",
    "ipsec_end_system",
    "ipsec_tunnel",
    "ipsec_user",
    "key_agreement",
    "key_encipherment",
    "microsoft_commercial_code_signing",
    "microsoft_kernel_code_signing",
    "microsoft_server_gated_crypto",
    "netscape_server_gated_crypto",
    "ocsp_signing",
    "server_auth",
    "timestamping"
  ]
}

resource "vault_pki_secret_backend_intermediate_set_signed" "certificate" {
  depends_on = [tls_locally_signed_cert.pki_intermediate_cert]
  backend    = vault_mount.pki.path
  certificate = format("%s\n%s", tls_locally_signed_cert.pki_intermediate_cert.cert_pem,
  file(var.VAULT_MONO_LOCAL_FILE_ROOT_CA_CERTIFICATE))
}

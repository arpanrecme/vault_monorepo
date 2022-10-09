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


resource "vault_pki_secret_backend_role" "master" {
  backend                  = vault_mount.pki.path
  name                     = "master"
  ttl                      = (0.25 * 365 * 24 * 3600) # Years * Days * Hours * Seconds
  max_ttl                  = (1 * 365 * 24 * 3600)    # Years * Days * Hours * Seconds
  allow_localhost          = true
  allowed_domains          = ["arpanrec.com", "*.arpanrec.com"]
  allow_subdomains         = true
  allow_bare_domains       = true
  allow_glob_domains       = true
  allow_any_name           = true
  allowed_domains_template = true
  server_flag              = true
  client_flag              = true
  code_signing_flag        = true
  email_protection_flag    = true
  key_type                 = "rsa"
  key_bits                 = 2048
  key_usage = [
    "DigitalSignature",
    "KeyAgreement",
    "KeyEncipherment"
  ]
  ext_key_usage = [
    "ExtKeyUsageServerAuth",
    "ExtKeyUsageClientAuth",
    "ExtKeyUsageCodeSigning",
    "ExtKeyUsageEmailProtection",
    "ExtKeyUsageIPSECEndSystem",
    "ExtKeyUsageIPSECTunnel",
    "ExtKeyUsageIPSECUser",
    "ExtKeyUsageTimeStamping",
    "ExtKeyUsageOCSPSigning",
    "ExtKeyUsageMicrosoftServerGatedCrypto",
    "ExtKeyUsageNetscapeServerGatedCrypto",
    "ExtKeyUsageMicrosoftCommercialCodeSigning",
    "ExtKeyUsageMicrosoftKernelCodeSigning"
  ]
  allow_ip_sans       = true
  use_csr_common_name = true
  use_csr_sans        = true
  require_cn          = true

}


resource "vault_pki_secret_backend_role" "web" {
  backend             = vault_mount.pki.path
  name                = "web"
  ttl                 = (0.25 * 365 * 24 * 3600) # Years * Days * Hours * Seconds
  max_ttl             = (1 * 365 * 24 * 3600)    # Years * Days * Hours * Seconds
  allow_localhost     = true
  allowed_domains     = ["arpanrec.com", "*.arpanrec.com"]
  client_flag         = false
  allow_subdomains    = true
  key_type            = "rsa"
  allow_ip_sans       = true
  use_csr_common_name = true
  use_csr_sans        = true
  require_cn          = true
  key_usage = [
    "DigitalSignature",
    "KeyAgreement",
    "KeyEncipherment"
  ]
}

resource "vault_pki_secret_backend_role" "mutual_client" {
  backend             = vault_mount.pki.path
  name                = "mutual_client"
  ttl                 = (0.25 * 365 * 24 * 3600) # Years * Days * Hours * Seconds
  max_ttl             = (1 * 365 * 24 * 3600)    # Years * Days * Hours * Seconds
  allow_localhost     = true
  allowed_domains     = ["arpanrec.com", "*.arpanrec.com"]
  client_flag         = true
  allow_subdomains    = true
  key_type            = "rsa"
  allow_ip_sans       = true
  use_csr_common_name = true
  use_csr_sans        = true
  require_cn          = true
  key_usage = [
    "DigitalSignature",
    "KeyAgreement",
    "KeyEncipherment"
  ]
}

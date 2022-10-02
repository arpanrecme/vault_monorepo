ui = true

default_lease_ttl = "768h"

disable_clustering = true

disable_mlock = true

listener "tcp" {
  address = "0.0.0.0:8200"
  tls_disable = false
  tls_cert_file = "/opt/vault/tls/tls_chain.crt"
  tls_key_file  = "/opt/vault/tls/tls.key"
  tls_require_and_verify_client_cert = true
  tls_client_ca_file = "/opt/vault/tls/root.crt"
}

log_level = "trace"

max_lease_ttl = "768h"

storage "file" {
  path = "/opt/vault/data"
}

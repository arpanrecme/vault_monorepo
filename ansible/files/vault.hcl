ui = true

default_lease_ttl = "768h"

disable_clustering = true

disable_mlock = true

listener "tcp" {
  address = "0.0.0.0:8200"
  tls_disable = false
  tls_cert_file = "/opt/vault/tls/tls.crt"
  tls_key_file  = "/opt/vault/tls/tls.key"
}

log_level = "trace"

max_lease_ttl = "768h"

storage "file" {
  path = "/opt/vault/data"
}

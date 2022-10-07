resource "vault_auth_backend" "userpass" {
  type = "userpass"
  tune {
    default_lease_ttl  = "768h"
    max_lease_ttl      = 0
    listing_visibility = "unauth"
  }
}

# resource "vault_auth_backend" "approle" {
#   type = "approle"
#   tune {
#     default_lease_ttl  = "768h"
#     max_lease_ttl      = 0
#     listing_visibility = "unauth"
#   }
# }
# resource "vault_approle_auth_backend_role" "mradmin" {
#   backend       = vault_auth_backend.approle.path
#   role_name     = "mradmin"
#   role_id       = "mradmin"
#   token_ttl     = 604800
#   token_max_ttl = 0
#   secret_id_ttl = 300
#   token_policies = [
#     "default",
#     vault_policy.admin.name
#   ]
#   token_period   = 604800
#   bind_secret_id = true
# }

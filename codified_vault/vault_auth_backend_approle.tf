resource "vault_auth_backend" "approle" {
  type = "approle"
  tune {
    default_lease_ttl  = "768h"
    max_lease_ttl      = "768h"
    listing_visibility = "unauth"
    token_type         = "default-service"
  }
}

resource "vault_approle_auth_backend_role" "scm_cicd" {
  backend        = vault_auth_backend.approle.path
  role_name      = "scm_cicd"
  token_policies = ["default", vault_policy.scm_cicd.name]
  secret_id_ttl  = 0
  role_id        = "scm_cicd"
}

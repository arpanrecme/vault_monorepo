resource "vault_auth_backend" "approle" {
  type = "approle"
  path = "approle"
  tune {
    default_lease_ttl  = "768h"
    max_lease_ttl      = "768h"
    listing_visibility = "unauth"
    token_type         = "default-service"
  }
}

resource "vault_approle_auth_backend_role" "scm_cicd" {
  depends_on = [
    vault_auth_backend.approle
  ]
  backend            = vault_auth_backend.approle.path
  role_name          = "scm_cicd"
  token_policies     = ["default", var.SCM_CICD_POLICY_NAME, var.DEFAULT_LOGIN_POLICY_NAME]
  secret_id_ttl      = 0
  role_id            = "scm_cicd"
  secret_id_num_uses = 0
}

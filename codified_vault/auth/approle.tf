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
  token_policies     = ["default", "scm_cicd", "default_login"]
  secret_id_ttl      = 0
  role_id            = "scm_cicd"
  secret_id_num_uses = 0
}

resource "vault_approle_auth_backend_role" "github_master_controller" {
  depends_on = [
    vault_auth_backend.approle
  ]
  backend            = vault_auth_backend.approle.path
  role_name          = "github_master_controller"
  token_policies     = ["default", "github_master_controller", "default_login"]
  secret_id_ttl      = 0
  role_id            = "github_master_controller"
  secret_id_num_uses = 0
}

resource "vault_approle_auth_backend_role" "gitlab_master_controller" {
  depends_on = [
    vault_auth_backend.approle
  ]
  backend            = vault_auth_backend.approle.path
  role_name          = "gitlab_master_controller"
  token_policies     = ["default", "gitlab_master_controller", "default_login"]
  secret_id_ttl      = 0
  role_id            = "gitlab_master_controller"
  secret_id_num_uses = 0
}

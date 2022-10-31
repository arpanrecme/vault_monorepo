resource "vault_approle_auth_backend_role" "scm_cicd" {
  backend            = vault_auth_backend.approle.path
  role_name          = "scm_cicd"
  token_policies     = ["default", vault_policy.scm_cicd.name]
  secret_id_ttl      = 0
  role_id            = "scm_cicd"
  secret_id_num_uses = 0
}

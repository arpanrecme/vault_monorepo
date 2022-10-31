resource "vault_approle_auth_backend_role" "scm_cicd" {
  depends_on = [
    vault_auth_backend.approle,
    module.policy.scm_cicd
  ]
  backend            = vault_auth_backend.approle.path
  role_name          = "scm_cicd"
  token_policies     = ["default", module.policy.scm_cicd]
  secret_id_ttl      = 0
  role_id            = "scm_cicd"
  secret_id_num_uses = 0
}

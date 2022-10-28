resource "random_password" "password_scm_cicd" {
  length           = 16
  special          = true
  override_special = "_"
}

resource "vault_generic_endpoint" "create_user_userpass_scm_cicd" {
  depends_on = [
    vault_auth_backend.userpass,
    vault_policy.scm_cicd,
    vault_policy.default_login
  ]
  path                 = "auth/userpass/users/scm_cicd"
  ignore_absent_fields = true

  data_json = <<EOT
{
  "policies": ["scm_cicd", "default", "default_login"],
  "password": "${random_password.password_scm_cicd.result}"
}
EOT
}

resource "random_password" "password_gitlab" {
  length           = 16
  special          = true
  override_special = "_"
}

resource "vault_generic_endpoint" "create_user_userpass_gitlab" {
  depends_on = [
    vault_auth_backend.userpass,
    vault_policy.gitlab,
    vault_policy.default_login
  ]
  path                 = "auth/userpass/users/gitlab"
  ignore_absent_fields = true

  data_json = <<EOT
{
  "policies": ["gitlab", "default", "default_login"],
  "password": "${random_password.password_gitlab.result}"
}
EOT
}

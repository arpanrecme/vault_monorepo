resource "random_password" "password_github" {
  length           = 16
  special          = true
  override_special = "_"
}

resource "vault_generic_endpoint" "create_user_userpass_github" {
  depends_on = [
    vault_auth_backend.userpass,
    vault_policy.github,
    vault_policy.default_login
  ]
  path                 = "auth/userpass/users/github"
  ignore_absent_fields = true

  data_json = <<EOT
{
  "policies": ["github", "default", "default_login"],
  "password": "${random_password.password_github.result}"
}
EOT
}

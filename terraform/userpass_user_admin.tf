resource "random_password" "password_admin" {
  length           = 16
  special          = true
  override_special = "_"
}

resource "vault_generic_endpoint" "create_user_userpass_admin" {
  depends_on = [
    vault_auth_backend.userpass,
    vault_policy.admin
  ]
  path                 = "auth/userpass/users/admin"
  ignore_absent_fields = true

  data_json = <<EOT
{
  "policies": ["admin"],
  "password": "${random_password.password_admin.result}"
}
EOT
}

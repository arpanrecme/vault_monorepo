resource "random_password" "password_backup_user" {
  length           = 16
  special          = true
  override_special = "_"
}

resource "vault_generic_endpoint" "create_user_userpass_backup_user" {
  depends_on = [
    vault_auth_backend.userpass,
    vault_policy.admin
  ]
  path                 = "auth/userpass/users/backup_user"
  ignore_absent_fields = true

  data_json = <<EOT
{
  "policies": ["admin"],
  "password": "${random_password.password_backup_user.result}"
}
EOT
}

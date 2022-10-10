
resource "random_password" "password_admin_read_only" {
  length           = 16
  special          = true
  override_special = "_"
}

resource "vault_generic_endpoint" "admin_read_only" {
  depends_on = [
    vault_auth_backend.userpass,
    vault_policy.admin_read_only
  ]
  path                 = "auth/userpass/users/admin_read_only"
  ignore_absent_fields = true

  data_json = <<EOT
{
  "policies": ["admin_read_only"],
  "password": "${random_password.password_admin_read_only.result}"
}
EOT
}

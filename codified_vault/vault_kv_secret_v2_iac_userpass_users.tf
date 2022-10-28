resource "vault_kv_secret_v2" "secret_userpass_gitlab" {
  mount = vault_mount.secret.path
  name  = "iac/vault/userpass/user/scm_cicd"
  data_json = jsonencode(
    {
      username = "scm_cicd"
      password = random_password.password_scm_cicd.result
    }
  )
}

resource "vault_kv_secret_v2" "secret_userpass_admin" {
  mount = vault_mount.secret.path
  name  = "iac/vault/userpass/user/admin"
  data_json = jsonencode(
    {
      username = "admin"
      password = random_password.password_admin.result
    }
  )
}

resource "vault_kv_secret_v2" "secret_userpass_admin_read_only" {
  mount = vault_mount.secret.path
  name  = "iac/vault/userpass/user/admin_read_only"
  data_json = jsonencode(
    {
      username = "admin_read_only"
      password = random_password.password_admin_read_only.result
    }
  )
}

resource "vault_kv_secret_v2" "secret_userpass_backup_user" {
  mount = vault_mount.secret.path
  name  = "iac/vault/userpass/user/backup_user"
  data_json = jsonencode(
    {
      username = "backup_user"
      password = random_password.password_backup_user.result
    }
  )
}

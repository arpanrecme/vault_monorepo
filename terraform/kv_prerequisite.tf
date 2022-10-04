resource "vault_kv_secret_v2" "secret" {
  mount = vault_mount.secret.path
  name  = "prerequisite/openssh"
  data_json = jsonencode(
    {
      private_key             = file(var.VAULT_MONO_LOCAL_FILE_OPENSSH_PRIVATE_KEY),
      public_key              = file(var.VAULT_MONO_LOCAL_FILE_OPENSSH_PUBLIC_KEY),
      private_key_passpharase = file(var.VAULT_MONO_LOCAL_FILE_OPENSSH_PASSPHRASE_PRIVATE_KEY)
    }
  )
}

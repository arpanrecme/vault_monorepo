resource "vault_kv_secret_v2" "secret_prerequisite_openssh" {
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

resource "vault_kv_secret_v2" "secret_prerequisite_openpgp" {
  mount = vault_mount.secret.path
  name  = "prerequisite/openpgp"
  data_json = jsonencode(
    {
      private_key             = file(var.VAULT_MONO_LOCAL_FILE_OPENPGP_PRIVATE_KEY),
      public_key              = file(var.VAULT_MONO_LOCAL_FILE_OPENPGP_PUBLIC_KEY),
      private_key_passpharase = file(var.VAULT_MONO_LOCAL_FILE_OPENPGP_PASSPHRASE_PRIVATE_KEY)
    }
  )
}

resource "vault_kv_secret_v2" "secret_prerequisite_linode" {
  mount = vault_mount.secret.path
  name  = "prerequisite/linode"
  data_json = jsonencode(
    {
      LINODE_CLI_PROD_TOKEN = file(var.VAULT_MONO_LOCAL_FILE_LINODE_CLI_PROD_TOKEN)
    }
  )
}

resource "vault_kv_secret_v2" "secret_prerequisite_rootca" {
  mount = vault_mount.secret.path
  name  = "prerequisite/rootca"
  data_json = jsonencode(
    {
      private_key             = file(var.VAULT_MONO_LOCAL_FILE_ROOT_CA_PRIVATE_KEY),
      certificate             = file(var.VAULT_MONO_LOCAL_FILE_ROOT_CA_CERTIFICATE),
      private_key_passpharase = file(var.VAULT_MONO_LOCAL_FILE_ROOT_CA_PASSPHRASE_PRIVATE_KEY)
    }
  )
}
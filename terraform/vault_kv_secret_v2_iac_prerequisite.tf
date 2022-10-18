resource "vault_kv_secret_v2" "secret_prerequisite_openssh" {
  mount = vault_mount.secret.path
  name  = "iac/prerequisite/openssh"
  data_json = jsonencode(
    {
      private_key        = file(var.VAULT_MONO_LOCAL_FILE_OPENSSH_PRIVATE_KEY)
      public_key         = file(var.VAULT_MONO_LOCAL_FILE_OPENSSH_PUBLIC_KEY)
      private_nopass_key = file(var.VAULT_MONO_LOCAL_FILE_OPENSSH_NOPASS_PRIVATE_KEY)
      passphrase         = file(var.VAULT_MONO_LOCAL_FILE_OPENSSH_PRIVATE_KEY_PASSPHRASE)
    }
  )
}

resource "vault_kv_secret_v2" "secret_prerequisite_linode" {
  mount = vault_mount.secret.path
  name  = "iac/prerequisite/linode"
  data_json = jsonencode(
    {
      LINODE_CLI_PROD_TOKEN = file(var.VAULT_MONO_LOCAL_FILE_LINODE_CLI_PROD_TOKEN)
    }
  )
}

resource "vault_kv_secret_v2" "secret_prerequisite_rootca" {
  mount = vault_mount.secret.path
  name  = "iac/prerequisite/rootca"
  data_json = jsonencode(
    {
      private_key_no_pass = file(var.VAULT_MONO_LOCAL_FILE_ROOT_CA_PRIVATE_KEY_NO_PASS)
      certificate         = file(var.VAULT_MONO_LOCAL_FILE_ROOT_CA_CERTIFICATE)
      private_key         = file(var.VAULT_MONO_LOCAL_FILE_ROOT_CA_PRIVATE_KEY)
      passphrase          = file(var.VAULT_MONO_LOCAL_FILE_ROOT_CA_PRIVATE_KEY_PASSPHRASE)
    }
  )
}

resource "vault_kv_secret_v2" "secret_prerequisite_gitlab" {
  mount = vault_mount.secret.path
  name  = "iac/prerequisite/gitlab"
  data_json = jsonencode(
    {
      username        = file(var.VAULT_MONO_LOCAL_FILE_GITLAB_USERNAME)
      GL_PROD_API_KEY = file(var.VAULT_MONO_LOCAL_FILE_GITLAB_GL_PROD_API_KEY)
    }
  )
}

resource "vault_kv_secret_v2" "secret_prerequisite_github" {
  mount = vault_mount.secret.path
  name  = "iac/prerequisite/github"
  data_json = jsonencode(
    {
      username          = file(var.VAULT_MONO_LOCAL_FILE_GITHUB_USERNAME)
      GH_PROD_API_TOKEN = file(var.VAULT_MONO_LOCAL_FILE_GITHUB_GH_PROD_API_TOKEN)
    }
  )
}

resource "vault_kv_secret_v2" "secret_prerequisite_terraform_cloud" {
  mount = vault_mount.secret.path
  name  = "iac/prerequisite/terraform_cloud"
  data_json = jsonencode(
    {
      TF_PROD_TOKEN = file(var.VAULT_MONO_LOCAL_FILE_TERRAFORM_CLOUD_TF_PROD_TOKEN)
    }
  )
}

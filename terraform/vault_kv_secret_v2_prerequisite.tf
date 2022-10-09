resource "vault_kv_secret_v2" "secret_prerequisite_openssh" {
  mount = vault_mount.secret.path
  name  = "prerequisite/openssh"
  data_json = jsonencode(
    {
      private_key = file(var.VAULT_MONO_LOCAL_FILE_OPENSSH_PRIVATE_KEY)
      public_key  = file(var.VAULT_MONO_LOCAL_FILE_OPENSSH_PUBLIC_KEY)
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
      private_key = file(var.VAULT_MONO_LOCAL_FILE_ROOT_CA_PRIVATE_KEY)
      certificate = file(var.VAULT_MONO_LOCAL_FILE_ROOT_CA_CERTIFICATE)
    }
  )
}

resource "vault_kv_secret_v2" "secret_prerequisite_gitlab" {
  mount = vault_mount.secret.path
  name  = "prerequisite/gitlab"
  data_json = jsonencode(
    {
      username        = file(var.VAULT_MONO_LOCAL_FILE_GITLAB_USERNAME)
      GL_PROD_API_KEY = file(var.VAULT_MONO_LOCAL_FILE_GITLAB_GL_PROD_API_KEY)
    }
  )
}

resource "vault_kv_secret_v2" "secret_prerequisite_github" {
  mount = vault_mount.secret.path
  name  = "prerequisite/github"
  data_json = jsonencode(
    {
      username          = file(var.VAULT_MONO_LOCAL_FILE_GITHUB_USERNAME)
      GH_PROD_API_TOKEN = file(var.VAULT_MONO_LOCAL_FILE_GITHUB_GH_PROD_API_TOKEN)
    }
  )
}

resource "vault_kv_secret_v2" "secret_prerequisite_ansibe_galaxy" {
  mount = vault_mount.secret.path
  name  = "prerequisite/ansibe_galaxy"
  data_json = jsonencode(
    {
      GALAXY_API_KEY = file(var.VAULT_MONO_LOCAL_FILE_ANSIBLE_GALAXY_API_KEY)
    }
  )
}

resource "vault_kv_secret_v2" "secret_prerequisite_terraform_cloud" {
  mount = vault_mount.secret.path
  name  = "prerequisite/terraform_cloud"
  data_json = jsonencode(
    {
      TF_PROD_TOKEN = file(var.VAULT_MONO_LOCAL_FILE_TERRAFORM_CLOUD_TF_PROD_TOKEN)
    }
  )
}

resource "vault_kv_secret_v2" "secret_prerequisite_openssh_master_public" {
  mount = vault_mount.secret.path
  name  = "prerequisite/openssh_master_public"
  data_json = jsonencode(
    {
      public_key = file(var.VAULT_MONO_LOCAL_FILE_OPENSSH_MASTER_PUBLIC_KEY)
    }
  )
}

resource "vault_kv_secret_v2" "secret_prerequisite_openpgp_master_public" {
  mount = vault_mount.secret.path
  name  = "prerequisite/openpgp_master_public"
  data_json = jsonencode(
    {
      public_key = file(var.VAULT_MONO_LOCAL_FILE_OPENPGP_MASTER_PUBLIC_KEY)
    }
  )
}

resource "vault_mount" "prerequisite" {
  path        = "prerequisite"
  type        = "kv-v2"
  description = "prerequisite Secret Data Store"
  options = {
    version              = 2
    cas_required         = false
    max_versions         = 20
    delete_version_after = "0s"
  }
}

resource "vault_kv_secret_v2" "prerequisite_linode" {
  mount = vault_mount.prerequisite.path
  name  = "linode"
  data_json = jsonencode(
    {
      LINODE_CLI_PROD_TOKEN = file(var.VAULT_MONO_LOCAL_FILE_LINODE_CLI_PROD_TOKEN)
    }
  )
}

resource "vault_kv_secret_v2" "prerequisite_gitlab" {
  mount = vault_mount.prerequisite.path
  name  = "gitlab"
  data_json = jsonencode(
    {
      GL_PROD_API_KEY = file(var.VAULT_MONO_LOCAL_FILE_GITLAB_GL_PROD_API_KEY)
    }
  )
}

resource "vault_kv_secret_v2" "prerequisite_github" {
  mount = vault_mount.prerequisite.path
  name  = "github"
  data_json = jsonencode(
    {
      GH_PROD_API_TOKEN = file(var.VAULT_MONO_LOCAL_FILE_GITHUB_GH_PROD_API_TOKEN)
    }
  )
}

resource "vault_kv_secret_v2" "prerequisite_ansibe_galaxy" {
  mount = vault_mount.prerequisite.path
  name  = "ansibe_galaxy"
  data_json = jsonencode(
    {
      GALAXY_API_KEY = file(var.VAULT_MONO_LOCAL_FILE_ANSIBLE_GALAXY_API_KEY)
    }
  )
}

resource "vault_kv_secret_v2" "prerequisite_terraform_cloud" {
  mount = vault_mount.prerequisite.path
  name  = "terraform_cloud"
  data_json = jsonencode(
    {
      TF_PROD_TOKEN = file(var.VAULT_MONO_LOCAL_FILE_TERRAFORM_CLOUD_TF_PROD_TOKEN)
    }
  )
}

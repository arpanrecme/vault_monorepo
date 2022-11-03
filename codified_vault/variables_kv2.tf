variable "VAULT_MONO_PREREQUISITE_LOCAL_FILE_LINODE_CLI_PROD_TOKEN" {
  type      = string
  default   = "../.tmp/prerequisite/linode_cli_prod_token.txt"
  sensitive = true
  validation {
    condition     = length(var.VAULT_MONO_PREREQUISITE_LOCAL_FILE_LINODE_CLI_PROD_TOKEN) > 1
    error_message = "Missing Linode Key file path"
  }
}

variable "VAULT_MONO_PREREQUISITE_LOCAL_FILE_GITLAB_GL_PROD_API_KEY" {
  type      = string
  default   = "../.tmp/prerequisite/gitlab_gl_prod_api_key.txt"
  sensitive = true
  validation {
    condition     = length(var.VAULT_MONO_PREREQUISITE_LOCAL_FILE_GITLAB_GL_PROD_API_KEY) > 1
    error_message = "Missing Gitlab API Key file path"
  }
}

variable "VAULT_MONO_PREREQUISITE_LOCAL_FILE_GITHUB_GH_PROD_API_TOKEN" {
  type      = string
  default   = "../.tmp/prerequisite/github_gh_prod_api_token.txt"
  sensitive = true
  validation {
    condition     = length(var.VAULT_MONO_PREREQUISITE_LOCAL_FILE_GITHUB_GH_PROD_API_TOKEN) > 1
    error_message = "Missing Github API Key file path"
  }
}

variable "VAULT_MONO_PREREQUISITE_LOCAL_FILE_ANSIBLE_GALAXY_API_KEY" {
  type      = string
  default   = "../.tmp/prerequisite/ansible_galaxy_api_key.txt"
  sensitive = true
  validation {
    condition     = length(var.VAULT_MONO_PREREQUISITE_LOCAL_FILE_ANSIBLE_GALAXY_API_KEY) > 1
    error_message = "Missing Ansible Galaxy API Key file path"
  }
}

variable "VAULT_MONO_PREREQUISITE_LOCAL_FILE_TERRAFORM_CLOUD_TF_PROD_TOKEN" {
  type      = string
  default   = "../.tmp/prerequisite/terraform_cloud_tf_prod_token.txt"
  sensitive = true
  validation {
    condition     = length(var.VAULT_MONO_PREREQUISITE_LOCAL_FILE_TERRAFORM_CLOUD_TF_PROD_TOKEN) > 1
    error_message = "Missing Terraform API Key file path"
  }
}

variable "VAULT_MONO_PREREQUISITE_LOCAL_FILE_VAULT_JWT_AUTH_BACKEND_OIDC_GSUITE_ADMIN" {
  type      = string
  default   = "../.tmp/prerequisite/vault_gsuite_oidc_conf.json"
  sensitive = true
  validation {
    condition     = length(var.VAULT_MONO_PREREQUISITE_LOCAL_FILE_VAULT_JWT_AUTH_BACKEND_OIDC_GSUITE_ADMIN) > 1
    error_message = "Missing Google Workspcae OIDC configuration file"
  }
}

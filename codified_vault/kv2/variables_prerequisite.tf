variable "VAULT_MONO_PREREQUISITE_LOCAL_FILE_LINODE_CLI_PROD_TOKEN" {
  type      = string
  default   = null
  sensitive = true
  validation {
    condition     = length(var.VAULT_MONO_PREREQUISITE_LOCAL_FILE_LINODE_CLI_PROD_TOKEN) > 1
    error_message = "Missing Linode Key file path"
  }
}

variable "VAULT_MONO_LOCAL_FILE_GITLAB_GL_PROD_API_KEY" {
  type      = string
  default   = null
  sensitive = true
  validation {
    condition     = length(var.VAULT_MONO_LOCAL_FILE_GITLAB_GL_PROD_API_KEY) > 1
    error_message = "Missing Gitlab API Key file path"
  }
}

variable "VAULT_MONO_LOCAL_FILE_GITHUB_GH_PROD_API_TOKEN" {
  type      = string
  default   = null
  sensitive = true
  validation {
    condition     = length(var.VAULT_MONO_LOCAL_FILE_GITHUB_GH_PROD_API_TOKEN) > 1
    error_message = "Missing Github API Key file path"
  }
}

variable "VAULT_MONO_LOCAL_FILE_ANSIBLE_GALAXY_API_KEY" {
  type      = string
  default   = null
  sensitive = true
  validation {
    condition     = length(var.VAULT_MONO_LOCAL_FILE_ANSIBLE_GALAXY_API_KEY) > 1
    error_message = "Missing Ansible Galaxy API Key file path"
  }
}

variable "VAULT_MONO_LOCAL_FILE_TERRAFORM_CLOUD_TF_PROD_TOKEN" {
  type      = string
  default   = null
  sensitive = true
  validation {
    condition     = length(var.VAULT_MONO_LOCAL_FILE_TERRAFORM_CLOUD_TF_PROD_TOKEN) > 1
    error_message = "Missing Terraform API Key file path"
  }
}

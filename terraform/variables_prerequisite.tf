variable "VAULT_MONO_LOCAL_FILE_OPENSSH_PRIVATE_KEY" {
  type    = string
  default = "../files/secrets.prerequisite.openssh_rsa_id.key"
  validation {
    condition     = length(var.VAULT_MONO_LOCAL_FILE_OPENSSH_PRIVATE_KEY) > 1
    error_message = "Missing OPEN SSH Private Key file path"
  }
}

variable "VAULT_MONO_LOCAL_FILE_OPENSSH_PUBLIC_KEY" {
  type    = string
  default = "../files/prerequisite.openssh_rsa_id.key.pub"
  validation {
    condition     = length(var.VAULT_MONO_LOCAL_FILE_OPENSSH_PUBLIC_KEY) > 1
    error_message = "Missing OPEN SSH Public Key file path"
  }
}

variable "VAULT_MONO_LOCAL_FILE_LINODE_CLI_PROD_TOKEN" {
  type    = string
  default = "../files/secrets.prerequisite.linode_cli_prod_token.txt"
  validation {
    condition     = length(var.VAULT_MONO_LOCAL_FILE_LINODE_CLI_PROD_TOKEN) > 1
    error_message = "Missing Linode Key file path"
  }
}

variable "VAULT_MONO_LOCAL_FILE_ROOT_CA_PRIVATE_KEY" {
  type    = string
  default = "../files/secrets.prerequisite.root_ca_private_key.key"
  validation {
    condition     = length(var.VAULT_MONO_LOCAL_FILE_ROOT_CA_PRIVATE_KEY) > 1
    error_message = "Missing Root CA Private key file path"
  }
}

# variable "VAULT_MONO_LOCAL_FILE_ROOT_CA_CERTIFICATE" {
#   type    = string
#   default = null
#   validation {
#     condition     = length(var.VAULT_MONO_LOCAL_FILE_ROOT_CA_CERTIFICATE) > 1
#     error_message = "Missing Root CA Certificate key file path"
#   }
# }

variable "VAULT_MONO_LOCAL_FILE_GITLAB_USERNAME" {
  type    = string
  default = "../files/prerequisite.gitlab_username.txt"
  validation {
    condition     = length(var.VAULT_MONO_LOCAL_FILE_GITLAB_USERNAME) > 1
    error_message = "Missing Gitlab Username file path"
  }
}

variable "VAULT_MONO_LOCAL_FILE_GITLAB_GL_PROD_API_KEY" {
  type    = string
  default = "../files/secrets.prerequisite.gitlab_gl_prod_api_key.txt"
  validation {
    condition     = length(var.VAULT_MONO_LOCAL_FILE_GITLAB_GL_PROD_API_KEY) > 1
    error_message = "Missing Gitlab API Key file path"
  }
}

variable "VAULT_MONO_LOCAL_FILE_GITHUB_USERNAME" {
  type    = string
  default = "../files/prerequisite.github_username.txt"
  validation {
    condition     = length(var.VAULT_MONO_LOCAL_FILE_GITHUB_USERNAME) > 1
    error_message = "Missing Github Username file path"
  }
}

variable "VAULT_MONO_LOCAL_FILE_GITHUB_GH_PROD_API_KEY" {
  type    = string
  default = "../files/secrets.prerequisite.github_gh_prod_api_key.txt"
  validation {
    condition     = length(var.VAULT_MONO_LOCAL_FILE_GITHUB_GH_PROD_API_KEY) > 1
    error_message = "Missing Github API Key file path"
  }
}

variable "VAULT_MONO_LOCAL_FILE_ANSIBLE_GALAXY_API_KEY" {
  type    = string
  default = "../files/secrets.prerequisite.ansible_galaxy_api_key.txt"
  validation {
    condition     = length(var.VAULT_MONO_LOCAL_FILE_ANSIBLE_GALAXY_API_KEY) > 1
    error_message = "Missing Ansible Galaxy API Key file path"
  }
}

variable "VAULT_MONO_LOCAL_FILE_TERRAFORM_CLOUD_TF_PROD_TOKEN" {
  type    = string
  default = "../files/secrets.prerequisite.terraform_cloud_tf_prod_token.txt"
  validation {
    condition     = length(var.VAULT_MONO_LOCAL_FILE_TERRAFORM_CLOUD_TF_PROD_TOKEN) > 1
    error_message = "Missing Terraform API Key file path"
  }
}

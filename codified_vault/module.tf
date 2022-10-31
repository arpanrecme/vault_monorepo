module "pki" {
  source = "./pki"

  providers = {
    vault = vault
  }

  vault_mono_vault_addr                             = local.vault_mono_vault_addr
  VAULT_MONO_LOCAL_FILE_ROOT_CA_NO_PASS_PRIVATE_KEY = var.VAULT_MONO_LOCAL_FILE_ROOT_CA_NO_PASS_PRIVATE_KEY
  VAULT_MONO_LOCAL_FILE_ROOT_CA_CERTIFICATE         = var.VAULT_MONO_LOCAL_FILE_ROOT_CA_CERTIFICATE
}

module "policy" {
  source = "./policy"

  providers = {
    vault = vault
  }
}

module "auth" {
  source = "./auth"

  providers = {
    vault = vault
  }

  vault_mono_vault_addr = local.vault_mono_vault_addr
  ADMIN_POLICY_NAME     = module.policy.admin
  SCM_CICD_POLICY_NAME  = module.policy.scm_cicd
}

module "kv2" {
  source = "./kv2"

  providers = {
    vault = vault
  }

  VAULT_MONO_LOCAL_FILE_LINODE_CLI_PROD_TOKEN                    = var.VAULT_MONO_LOCAL_FILE_LINODE_CLI_PROD_TOKEN
  VAULT_MONO_LOCAL_FILE_GITLAB_GL_PROD_API_KEY                   = var.VAULT_MONO_LOCAL_FILE_GITLAB_GL_PROD_API_KEY
  VAULT_MONO_LOCAL_FILE_GITHUB_GH_PROD_API_TOKEN                 = var.VAULT_MONO_LOCAL_FILE_GITHUB_GH_PROD_API_TOKEN
  VAULT_MONO_LOCAL_FILE_ANSIBLE_GALAXY_API_KEY                   = var.VAULT_MONO_LOCAL_FILE_ANSIBLE_GALAXY_API_KEY
  VAULT_MONO_LOCAL_FILE_TERRAFORM_CLOUD_TF_PROD_TOKEN            = var.VAULT_MONO_LOCAL_FILE_TERRAFORM_CLOUD_TF_PROD_TOKEN
  VAULT_MONO_LOCAL_FILE_VAULT_JWT_AUTH_BACKEND_OIDC_GSUITE_ADMIN = var.VAULT_MONO_LOCAL_FILE_VAULT_JWT_AUTH_BACKEND_OIDC_GSUITE_ADMIN
}

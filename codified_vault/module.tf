module "pki" {
  source = "./pki"

  providers = {
    vault = vault
  }

  vault_mono_global_config_vault_addr                            = local.vault_mono_global_config_vault_addr
  vault_mono_global_config_vault_fqdn                            = local.vault_mono_global_config_vault_fqdn
  VAULT_MONO_PREREQUISITE_LOCAL_FILE_ROOT_CA_NO_PASS_PRIVATE_KEY = var.VAULT_MONO_PREREQUISITE_LOCAL_FILE_ROOT_CA_NO_PASS_PRIVATE_KEY
  vault_mono_global_config_root_ca_certificate                   = local.vault_mono_global_config_root_ca_certificate
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

  vault_mono_global_config_vault_addr = local.vault_mono_global_config_vault_addr
  ADMIN_POLICY_NAME                   = module.policy.admin
  SCM_CICD_POLICY_NAME                = module.policy.scm_cicd
  DEFAULT_LOGIN_POLICY_NAME           = module.policy.default_login

  VAULT_MONO_PREREQUISITE_LOCAL_FILE_AUTH0_CLIENT_DETAILS = var.VAULT_MONO_PREREQUISITE_LOCAL_FILE_AUTH0_CLIENT_DETAILS
}

module "kv2" {
  source = "./kv2"

  providers = {
    vault = vault
  }

  VAULT_MONO_PREREQUISITE_LOCAL_FILE_LINODE_CLI_PROD_TOKEN         = var.VAULT_MONO_PREREQUISITE_LOCAL_FILE_LINODE_CLI_PROD_TOKEN
  VAULT_MONO_PREREQUISITE_LOCAL_FILE_GITLAB_GL_PROD_API_KEY        = var.VAULT_MONO_PREREQUISITE_LOCAL_FILE_GITLAB_GL_PROD_API_KEY
  VAULT_MONO_PREREQUISITE_LOCAL_FILE_GITHUB_GH_PROD_API_TOKEN      = var.VAULT_MONO_PREREQUISITE_LOCAL_FILE_GITHUB_GH_PROD_API_TOKEN
  VAULT_MONO_PREREQUISITE_LOCAL_FILE_ANSIBLE_GALAXY_API_KEY        = var.VAULT_MONO_PREREQUISITE_LOCAL_FILE_ANSIBLE_GALAXY_API_KEY
  VAULT_MONO_PREREQUISITE_LOCAL_FILE_TERRAFORM_CLOUD_TF_PROD_TOKEN = var.VAULT_MONO_PREREQUISITE_LOCAL_FILE_TERRAFORM_CLOUD_TF_PROD_TOKEN
}

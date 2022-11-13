variable "SCM_CICD_POLICY_NAME" {
  type    = string
  default = null
  validation {
    condition     = length(var.SCM_CICD_POLICY_NAME) > 1
    error_message = "missing scm cicd policy name"
  }
}

variable "DEFAULT_LOGIN_POLICY_NAME" {
  type    = string
  default = null
  validation {
    condition     = length(var.DEFAULT_LOGIN_POLICY_NAME) > 1
    error_message = "missing scm cicd policy name"
  }
}

variable "ADMIN_POLICY_NAME" {
  type    = string
  default = null
  validation {
    condition     = length(var.ADMIN_POLICY_NAME) > 1
    error_message = "missing admin policy name"
  }
}

variable "vault_mono_global_config_vault_addr" {
  type    = string
  default = null
  validation {
    condition     = length(var.vault_mono_global_config_vault_addr) > 1
    error_message = "missing vault address"
  }
}

variable "VAULT_MONO_PREREQUISITE_LOCAL_FILE_AUTH0_CLIENT_DETAILS" {
  type      = string
  default   = null
  sensitive = true
  validation {
    condition     = length(var.VAULT_MONO_PREREQUISITE_LOCAL_FILE_AUTH0_CLIENT_DETAILS) > 1
    error_message = "missing auth0 client application details"
  }
}

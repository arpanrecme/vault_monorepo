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

variable "vault_mono_vault_addr" {
  type    = string
  default = null
  validation {
    condition     = length(var.vault_mono_vault_addr) > 1
    error_message = "missing vault address"
  }
}

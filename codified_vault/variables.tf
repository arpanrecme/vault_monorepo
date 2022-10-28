variable "VAULT_MONO_LOCAL_FILE_GLOBAL_CONFIG" {
  type    = string
  default = "../files/config.json"
  validation {
    condition     = length(var.VAULT_MONO_LOCAL_FILE_GLOBAL_CONFIG) > 1
    error_message = "Missing global config file path"
  }
}

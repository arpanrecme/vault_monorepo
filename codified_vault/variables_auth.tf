variable "VAULT_MONO_PREREQUISITE_LOCAL_FILE_AUTH0_CLIENT_DETAILS" {
  type      = string
  default   = "../.tmp/prerequisite/auth0_client_details.json"
  sensitive = true
  validation {
    condition     = length(var.VAULT_MONO_PREREQUISITE_LOCAL_FILE_AUTH0_CLIENT_DETAILS) > 1
    error_message = "missing auth0 client application details"
  }
}

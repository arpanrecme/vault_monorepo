
variable "VAULT_MONO_PREREQUISITE_LOCAL_FILE_ROOT_CA_NO_PASS_PRIVATE_KEY" {
  type      = string
  default   = "../.tmp/prerequisite/root_ca_no_pass_private_key.pem"
  sensitive = true
  validation {
    condition     = length(var.VAULT_MONO_PREREQUISITE_LOCAL_FILE_ROOT_CA_NO_PASS_PRIVATE_KEY) > 1
    error_message = "Missing Root CA Private key file path"
  }
}

variable "VAULT_MONO_PREREQUISITE_LOCAL_FILE_ROOT_CA_CERTIFICATE" {
  type    = string
  default = "../.tmp/prerequisite/root_ca_certificate.pem"
  validation {
    condition     = length(var.VAULT_MONO_PREREQUISITE_LOCAL_FILE_ROOT_CA_CERTIFICATE) > 1
    error_message = "Missing root CA certificate file path"
  }
}

variable "vault_mono_local_file_global_config" {
  type    = string
  default = "../config.json"
}

variable "vault_mono_local_file_vault_init_secrets" {
  type    = string
  default = "../secrets.vault_init_secrets.json"
}

variable "vault_mono_local_file_root_certificate" {
  type    = string
  default = "../secrets.root_certificate.crt"
}

variable "vault_mono_local_file_client_private_key" {
  type    = string
  default = "../secrets.client_private_key.key"
}

variable "vault_mono_local_file_client_certificate" {
  type    = string
  default = "../secrets.client_certificate.crt"
}

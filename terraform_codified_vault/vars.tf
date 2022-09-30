# Use Vault provider
variable "VAULT_ADDR" {
  type    = string
  default = ""
}

variable "VAULT_TOKEN" {
  type      = string
  default   = ""
  sensitive = true
}

/* resource "vault_policy" "default" {
  name = "default"
  policy = file("sys/policies/default.hcl")
} */

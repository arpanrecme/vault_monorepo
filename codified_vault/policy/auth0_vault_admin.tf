data "vault_policy_document" "auth0_vault_admin" {
  rule {
    path         = "*"
    capabilities = ["create", "read", "update", "delete", "list", "sudo"]
    description  = "Allow all resources on vault for super admin users"
  }
}
resource "vault_policy" "auth0_vault_admin" {
  name   = "auth0_vault_admin"
  policy = data.vault_policy_document.auth0_vault_admin.hcl
}

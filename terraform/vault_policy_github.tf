data "vault_policy_document" "github" {
  rule {
    path         = "secret/*"
    capabilities = ["read", "list"]
    description  = "Allow to read resources on vault for github user"
  }
}

resource "vault_policy" "github" {
  name   = "github"
  policy = data.vault_policy_document.github.hcl
}

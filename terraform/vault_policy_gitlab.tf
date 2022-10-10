data "vault_policy_document" "gitlab" {
  rule {
    path         = "secret/*"
    capabilities = ["read", "list"]
    description  = "Allow to read resources on vault for gitlab user"
  }
}

resource "vault_policy" "gitlab" {
  name   = "gitlab"
  policy = data.vault_policy_document.gitlab.hcl
}

data "vault_policy_document" "gitlab" {

  rule {
    path         = "secret/data/iac/prerequisite/*"
    capabilities = ["read"]
    description  = "Allow to read prerequisites"
  }

  rule {
    path         = "secret/data/iac/vault/userpass/user/gitlab"
    capabilities = ["read"]
    description  = "Allow to read vault gitlab user cerdentials"
  }

  rule {
    path         = "pki/issue/client_certificate"
    capabilities = ["create", "update", "read"]
    description  = "Allow to create TLS client certificats"
  }
}

resource "vault_policy" "gitlab" {
  name   = "gitlab"
  policy = data.vault_policy_document.gitlab.hcl
}

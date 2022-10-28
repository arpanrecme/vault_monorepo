data "vault_policy_document" "scm_cicd" {

  rule {
    path         = "secret/data/iac/prerequisite/*"
    capabilities = ["read"]
    description  = "Allow to read prerequisites"
  }

  rule {
    path         = "secret/data/iac/vault/userpass/user/scm_cicd"
    capabilities = ["read"]
    description  = "Allow to read vault scm_cicd user cerdentials"
  }

  rule {
    path         = "pki/issue/client_certificate"
    capabilities = ["create", "update", "read"]
    description  = "Allow to create TLS client certificats"
  }
}

resource "vault_policy" "scm_cicd" {
  name   = "scm_cicd"
  policy = data.vault_policy_document.scm_cicd.hcl
}

data "vault_policy_document" "scm_cicd" {

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

output "scm_cicd" {
  value = vault_policy.scm_cicd.name
}

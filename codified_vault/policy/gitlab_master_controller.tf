data "vault_policy_document" "gitlab_master_controller" {
  rule {
    path         = "pki/issue/vault_client_certificate"
    capabilities = ["create", "update", "read"]
    description  = "Allow to create TLS client certificats for vault server"
  }
}

resource "vault_policy" "gitlab_master_controller" {
  name   = "gitlab_master_controller"
  policy = data.vault_policy_document.gitlab_master_controller.hcl
}

data "vault_policy_document" "github_master_controller" {
  rule {
    path         = "pki/issue/vault_client_certificate"
    capabilities = ["create", "update", "read"]
    description  = "Allow to create TLS client certificats for vault server"
  }
  rule {
    path         = "prerequisite/data/github"
    capabilities = ["read"]
    description  = "read github credentials"
  }
  rule {
    path         = "prerequisite/data/terraform_cloud"
    capabilities = ["read"]
    description  = "read terraform_cloud credentials"
  }
}

resource "vault_policy" "github_master_controller" {
  name   = "github_master_controller"
  policy = data.vault_policy_document.github_master_controller.hcl
}

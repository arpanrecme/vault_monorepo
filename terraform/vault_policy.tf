data "vault_policy_document" "admin" {
  rule {
    path         = "*"
    capabilities = ["create", "read", "update", "delete", "list", "sudo"]
    description  = "Allow all resources on vault for super admin users"
  }
}
resource "vault_policy" "admin" {
  name   = "admin"
  policy = data.vault_policy_document.admin.hcl
}

data "vault_policy_document" "admin_read_only" {
  rule {
    path         = "*"
    capabilities = ["read", "list"]
    description  = "Allow to read resources on vault for super admin users"
  }
}
resource "vault_policy" "admin_read_only" {
  name   = "admin_read_only"
  policy = data.vault_policy_document.admin_read_only.hcl
}

data "vault_policy_document" "gitlab" {
  rule {
    path         = "secret/prerequisite/*"
    capabilities = ["read", "list"]
    description  = "Allow to read resources on vault for gitlab user"
  }
}

resource "vault_policy" "gitlab" {
  name   = "gitlab"
  policy = data.vault_policy_document.gitlab.hcl
}

# data "vault_policy_document" "mradmin" {
#   rule {
#     path         = "database/creds/mysql_healthify*"
#     capabilities = ["read"]
#     description  = "Allow to create database user for mysql healthify db"
#   }
#   rule {
#     path         = "database/secret/healthify*"
#     capabilities = ["read", "list", "update", "delete", "create"]
#     description  = "Allow to access healthify secret space"
#   }
# }

# resource "vault_policy" "mradmin" {
#   name   = "mradmin"
#   policy = data.vault_policy_document.mradmin.hcl
#   /* file("sys/policies/admin.hcl") */
# }

# Use Vault provider
/* resource "vault_policy" "default" {
  name = "default"
  policy = file("sys/policies/default.hcl")
} */

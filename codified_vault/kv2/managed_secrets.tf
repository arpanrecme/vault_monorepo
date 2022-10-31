resource "vault_mount" "managed_secrets" {
  path        = "managed_secrets"
  type        = "kv-v2"
  description = "managed_secrets"
  options = {
    version              = 2
    cas_required         = false
    max_versions         = 20
    delete_version_after = "0s"
  }
}

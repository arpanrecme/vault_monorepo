resource "vault_mount" "managed_ansible_inventory" {
  path        = "managed_ansible_inventory"
  type        = "kv-v2"
  description = "managed_ansible_inventory"
  options = {
    version              = 2
    cas_required         = false
    max_versions         = 20
    delete_version_after = "0s"
  }
}

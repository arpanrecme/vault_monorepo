resource "vault_mount" "ansible_inventory" {
  path        = "ansible_inventory"
  type        = "kv-v2"
  description = "Ansible Inventory"
  options = {
    version              = 2
    cas_required         = false
    max_versions         = 20
    delete_version_after = "0s"
  }
}

terraform {
  backend "remote" {
    workspaces {
      name = "vault_mono_codified_vault"
    }
  }
}

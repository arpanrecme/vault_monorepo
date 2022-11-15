variable "VAULT_MONO_GLOBAL_CONFIG_ENDPOINT" {
  type    = string
  default = "https://raw.githubusercontent.com/arpanrecme/dotfiles/main/.config/global.json"
  validation {
    condition     = length(var.VAULT_MONO_GLOBAL_CONFIG_ENDPOINT) > 1
    error_message = "Missing global config file path"
  }
}

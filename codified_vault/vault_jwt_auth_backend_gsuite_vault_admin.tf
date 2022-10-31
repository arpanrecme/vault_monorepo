locals {
  gsuite_auth_admin_details                = jsondecode(file(var.VAULT_MONO_LOCAL_FILE_VAULT_JWT_AUTH_BACKEND_OIDC_GSUITE_ADMIN))
  gsuite_admin_oidc_client_id              = local.gsuite_auth_admin_details["oauth_client"]["web"]["client_id"]
  gsuite_admin_oidc_client_secret          = local.gsuite_auth_admin_details["oauth_client"]["web"]["client_secret"]
  gsuite_admin_gsuite_admin_impersonate    = local.gsuite_auth_admin_details["gsuite_admin_impersonate"]
  gsuite_admin_gsuite_service_account      = jsonencode(local.gsuite_auth_admin_details["service_account"])
  gsuite_admin_gsuite_admin_vault_ad_group = local.gsuite_auth_admin_details["gsuite_vault_admin_group_mail"]
}

resource "vault_jwt_auth_backend" "gsuite_admin" {
  description        = "Google Workspace Backend"
  path               = "gsuite_admin"
  type               = "oidc"
  oidc_discovery_url = "https://accounts.google.com"
  oidc_client_id     = local.gsuite_admin_oidc_client_id
  oidc_client_secret = local.gsuite_admin_oidc_client_secret
  default_role       = "gsuite_admin_role"
  tune {
    default_lease_ttl  = "30m"
    max_lease_ttl      = "1h"
    listing_visibility = "unauth"
    token_type         = "default-service"
  }
  provider_config = {
    provider                 = "gsuite"
    fetch_groups             = true
    fetch_user_info          = true
    groups_recurse_max_depth = 5
    gsuite_service_account   = local.gsuite_admin_gsuite_service_account,
    gsuite_admin_impersonate = local.gsuite_admin_gsuite_admin_impersonate
  }
}

resource "vault_jwt_auth_backend_role" "gsuite_admin_default_role" {
  depends_on = [
    vault_jwt_auth_backend.gsuite_admin
  ]
  backend               = vault_jwt_auth_backend.gsuite_admin.path
  role_name             = vault_jwt_auth_backend.gsuite_admin.default_role
  token_policies        = ["default"]
  groups_claim          = "groups"
  user_claim            = "sub"
  role_type             = "oidc"
  oidc_scopes           = ["profile", "email", "openid"]
  allowed_redirect_uris = ["${local.vault_mono_vault_addr}/ui/vault/auth/${vault_jwt_auth_backend.gsuite_admin.path}/oidc/callback", "http://localhost:8250/oidc/callback"]
  # bound_claims = {
  #   groups = "vault_admin@arpanrec.com"
  #   hd = var.hd
  # }
  claim_mappings = {
    email = "email"
  }
}

resource "vault_identity_group" "gsuite_admin_vault_ad_group" {
  depends_on = [
    vault_jwt_auth_backend_role.gsuite_admin_default_role,
    module.policy.admin
  ]
  name     = local.gsuite_admin_gsuite_admin_vault_ad_group
  type     = "external"
  policies = [module.policy.admin]

  metadata = {
    responsibility = "Vault Admin"
  }
}

resource "vault_identity_group_alias" "gsuite_admin_vault_ad_group_alias" {
  depends_on = [
    vault_identity_group.gsuite_admin_vault_ad_group
  ]
  name           = local.gsuite_admin_gsuite_admin_vault_ad_group
  mount_accessor = vault_jwt_auth_backend.gsuite_admin.accessor
  canonical_id   = vault_identity_group.gsuite_admin_vault_ad_group.id
}

resource "vault_jwt_auth_backend" "auth0" {
  description        = "auth0 Backend"
  path               = "auth0"
  type               = "oidc"
  oidc_discovery_url = "https://arpanrec.us.auth0.com/"
  oidc_client_id     = "oLapiQO0f4dXRaVS88b4gc3PZR1sWe5R"
  oidc_client_secret = ""
  default_role       = "auth0_default"
  tune {
    default_lease_ttl  = "30m"
    max_lease_ttl      = "1h"
    listing_visibility = "unauth"
    token_type         = "default-service"
  }
}

resource "vault_jwt_auth_backend_role" "auth0_default_role" {
  depends_on = [
    vault_jwt_auth_backend.auth0
  ]
  bound_audiences = ["oLapiQO0f4dXRaVS88b4gc3PZR1sWe5R"]
  backend         = vault_jwt_auth_backend.auth0.path
  role_name       = vault_jwt_auth_backend.auth0.default_role
  token_policies  = ["default"]
  user_claim      = "sub"
  role_type       = "oidc"
  allowed_redirect_uris = [
    "${var.vault_mono_global_config_vault_addr}/ui/vault/auth/${vault_jwt_auth_backend.auth0.path}/oidc/callback",
    "http://localhost:8250/oidc/callback"
  ]
}

resource "vault_jwt_auth_backend_role" "auth0_admin_role" {
  depends_on = [
    vault_jwt_auth_backend.auth0
  ]
  bound_audiences = ["oLapiQO0f4dXRaVS88b4gc3PZR1sWe5R"]
  backend         = vault_jwt_auth_backend.auth0.path
  role_name       = "admin_role"
  token_policies  = ["default"]
  user_claim      = "sub"
  role_type       = "oidc"
  allowed_redirect_uris = [
    "${var.vault_mono_global_config_vault_addr}/ui/vault/auth/${vault_jwt_auth_backend.auth0.path}/oidc/callback",
    "http://localhost:8250/oidc/callback"
  ]
  groups_claim = "hashicorp_vault_auth0_roles"
}

resource "vault_identity_group" "auth0_admin_vault_ad_group" {
  depends_on = [
    vault_jwt_auth_backend.auth0
  ]
  name     = "Auth0 Vault Admin"
  type     = "external"
  policies = [var.ADMIN_POLICY_NAME]

  metadata = {
    responsibility = "Vault Admin"
  }
}

resource "vault_identity_group_alias" "auth0_admin_vault_ad_group_alias" {
  depends_on = [
    vault_identity_group.auth0_admin_vault_ad_group
  ]
  name           = "kv-mgr"
  mount_accessor = vault_jwt_auth_backend.auth0.accessor
  canonical_id   = vault_identity_group.auth0_admin_vault_ad_group.id
}

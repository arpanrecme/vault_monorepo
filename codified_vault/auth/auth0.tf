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

resource "vault_jwt_auth_backend_role" "auth0_default" {
  depends_on = [
    vault_jwt_auth_backend.auth0
  ]
  bound_audiences = ["oLapiQO0f4dXRaVS88b4gc3PZR1sWe5R"]
  backend         = vault_jwt_auth_backend.auth0.path
  role_name       = vault_jwt_auth_backend.auth0.default_role
  token_policies  = [var.DEFAULT_LOGIN_POLICY_NAME]
  user_claim      = "sub"
  role_type       = "oidc"
  allowed_redirect_uris = [
    "${var.vault_mono_global_config_vault_addr}/ui/vault/auth/${vault_jwt_auth_backend.auth0.path}/oidc/callback",
    "http://localhost:8250/oidc/callback"
  ]
}

resource "vault_jwt_auth_backend_role" "auth0_vault_admin" {
  depends_on = [
    vault_jwt_auth_backend.auth0
  ]
  bound_audiences = ["oLapiQO0f4dXRaVS88b4gc3PZR1sWe5R"]
  backend         = vault_jwt_auth_backend.auth0.path
  role_name       = "auth0_vault_admin"
  token_policies  = [var.DEFAULT_LOGIN_POLICY_NAME]
  user_claim      = "sub"
  role_type       = "oidc"
  allowed_redirect_uris = [
    "${var.vault_mono_global_config_vault_addr}/ui/vault/auth/${vault_jwt_auth_backend.auth0.path}/oidc/callback",
    "http://localhost:8250/oidc/callback"
  ]
  groups_claim = "https://example.com/roles"
}

resource "vault_identity_group" "auth0_admin" {
  depends_on = [
    vault_jwt_auth_backend.auth0
  ]
  name     = "auth0_admin"
  type     = "external"
  policies = [var.ADMIN_POLICY_NAME]

  metadata = {
    responsibility = "Auth0 Vault Admin"
  }
}

resource "vault_identity_group_alias" "auth0_vault_admin" {
  depends_on = [
    vault_identity_group.auth0_admin
  ]
  name           = "auth0_vault_admin"
  mount_accessor = vault_jwt_auth_backend.auth0.accessor
  canonical_id   = vault_identity_group.auth0_admin.id
}

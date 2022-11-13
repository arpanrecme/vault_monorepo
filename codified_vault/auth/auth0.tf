locals {
  vault_mono_prerequisite_auth0_client_details     = jsondecode(file(var.VAULT_MONO_PREREQUISITE_LOCAL_FILE_AUTH0_CLIENT_DETAILS))
  vault_mono_prerequisite_auth0_oidc_client_id     = local.vault_mono_prerequisite_auth0_client_details.client_id
  vault_mono_prerequisite_auth0_oidc_client_secret = local.vault_mono_prerequisite_auth0_client_details.client_secret
  vault_mono_prerequisite_auth0_groups_claim       = local.vault_mono_prerequisite_auth0_client_details.groups_claim
  vault_mono_prerequisite_auth0_admin_role_name    = local.vault_mono_prerequisite_auth0_client_details.admin_role_name
  vault_mono_prerequisite_auth0_domain             = local.vault_mono_prerequisite_auth0_client_details.domain
}

resource "vault_jwt_auth_backend" "auth0" {
  description        = "auth0 Backend"
  path               = "auth0"
  type               = "oidc"
  oidc_discovery_url = "https://${local.vault_mono_prerequisite_auth0_domain}/"
  oidc_client_id     = local.vault_mono_prerequisite_auth0_oidc_client_id
  oidc_client_secret = local.vault_mono_prerequisite_auth0_oidc_client_secret
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
  bound_audiences = [local.vault_mono_prerequisite_auth0_oidc_client_id]
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
  bound_audiences = [local.vault_mono_prerequisite_auth0_oidc_client_id]
  backend         = vault_jwt_auth_backend.auth0.path
  role_name       = local.vault_mono_prerequisite_auth0_admin_role_name
  token_policies  = [var.DEFAULT_LOGIN_POLICY_NAME]
  user_claim      = "sub"
  role_type       = "oidc"
  allowed_redirect_uris = [
    "${var.vault_mono_global_config_vault_addr}/ui/vault/auth/${vault_jwt_auth_backend.auth0.path}/oidc/callback",
    "http://localhost:8250/oidc/callback"
  ]
  groups_claim = local.vault_mono_prerequisite_auth0_groups_claim
}

resource "vault_identity_group" "auth0_admin" {
  depends_on = [
    vault_jwt_auth_backend.auth0
  ]
  name     = local.vault_mono_prerequisite_auth0_admin_role_name
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
  name           = local.vault_mono_prerequisite_auth0_admin_role_name
  mount_accessor = vault_jwt_auth_backend.auth0.accessor
  canonical_id   = vault_identity_group.auth0_admin.id
}

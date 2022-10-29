resource "vault_jwt_auth_backend" "auth0_admin" {
  description        = "Aut0 Backend"
  path               = "auth0_admin"
  type               = "oidc"
  oidc_discovery_url = "https://arpanrec.us.auth0.com/"
  oidc_client_id     = ""
  oidc_client_secret = ""
  default_role       = "auth0_admin"
  # bound_issuer       = "https://myco.auth0.com/"
  tune {
    default_lease_ttl  = "768h"
    max_lease_ttl      = 0
    listing_visibility = "unauth"
  }
}

resource "vault_jwt_auth_backend_role" "auth0_admin" {
  depends_on = [
    vault_jwt_auth_backend.auth0_admin, vault_policy.admin
  ]
  bound_audiences = [""]
  backend         = vault_jwt_auth_backend.auth0_admin.path
  role_name       = "auth0_admin"
  token_policies  = [vault_policy.admin.name]

  user_claim            = "sub"
  role_type             = "oidc"
  allowed_redirect_uris = ["https://vault.arpanrec.com:8200/ui/vault/auth/auth0_admin/oidc/callback", "https://localhost:8250/oidc/callback"]
}

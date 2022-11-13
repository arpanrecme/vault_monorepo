# Vault Monolithic Repository

Flow:

Create Server ->

Patch System -> `patch_server`

Install Hashicorp Vault -> `install_vault`

Server TLS Certificate -> `install_vault`

Setup Client Certificate ->

Get Vault Initial Secret ->

Initialize and Unseal -> `vault_init_unseal`

Update Vault initial secret ->

Terraform Cloud Setup -> Create Organization and Workspace

Terraform Codified Vault -> `codified_vault`

Flow to downstream ->

## Prerequisite: Download the below resources from [bitwarden](tasks/get_prerequisite.yml)

- OPENSSH KEY
  - Private Key: `id_rsa`
  - Private Key Passphrase
- CA ROOT - RSA PRIVATE KEY and CERTIFICATE - 16:73:5a:f9:ed:ae:aa:98:26:cb:cc:0c:f2:9b:29:ec:88:4c:4b:e9
  - Private Key: `key.pem`
  - Private Key Passphrase
  - Certificate: `cert_full_chain.pem`
- Linode: `LINODE_CLI_PROD_TOKEN`
- GITLAB: `GL_PROD_API_KEY`
- GITHUB: `GH_PROD_API_TOKEN`
- Ansible Galaxy: `GALAXY_API_KEY`
- HashiCorp Terraform Cloud: `TF_PROD_TOKEN`
- Auth0 Client Details: `auth0_vault_admin.json`
  - Auth0 Domain
  - Client ID
  - Secret ID
  - Group Claim: `https://example.com/roles`
  - User app_metadata, Admin Role Name: `auth0_vault_admin`

```json
{
  "domain": "",
  "client_id": "",
  "client_secret": "",
  "groups_claim": "",
  "admin_role_name": ""
}
```

## [Create the server in Linode](tasks/100-create_server.yml)

## [Vault Configuration using Terraform](codified_vault/)

Source: [Codify Management of HCP Vault](https://developer.hashicorp.com/vault/tutorials/cloud-ops/vault-codify-mgmt)

Setup vault configuration using terraform

Backend state is stored in [Terraform Cloud](https://app.terraform.io/app/arpanrecme/workspaces/vault_mono_codified_vault)

- Organization: `arpanrecme`
  - Workspace: `two_factor_mandatory`

## Artifacts

[GitLab info](vars/gitlab_artifacts.yml)

- Terraform state stored in gitlab

## Vault Authentication - Auth0 Client Details

[Auth0 OIDC Auth Method](https://developer.hashicorp.com/vault/tutorials/auth-methods/oidc-auth)

- Create Application - Single page web application
- Update the callback URLs
  - `${var.vault_mono_global_config_vault_addr}/ui/vault/auth/${vault_jwt_auth_backend.auth0.path}/oidc/callback`
  - `http://localhost:8250/oidc/callback`
- Edit user's `app_metadata`

```json
{
  "roles": [
    "auth0_vault_admin"
  ]
}
```

- `Auth Pipeline` -> `Rules` -> `Create` -> `Empty rule`

```js
function (user, context, callback) {
  user.app_metadata = user.app_metadata || {};
  context.idToken["https://example.com/roles"] = user.app_metadata.roles || [];
  callback(null, user, context);
}
```

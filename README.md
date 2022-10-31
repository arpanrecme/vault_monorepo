# Vault Monolithic Repository

## Prerequisite: Download the below resources from [bitwarden](tasks/011-get_prerequisite.yml)

- OPENSSH KEY - SHA256:Nu4xUoniFGACilNjH9RB+3M1p4UoX8S71DVpPhZOBJ0
  - Private Key: `id_rsa`
- CA ROOT - RSA PRIVATE KEY and CERTIFICATE - 16:73:5a:f9:ed:ae:aa:98:26:cb:cc:0c:f2:9b:29:ec:88:4c:4b:e9
  - Private Key: `key.pem`
  - Certificate: `cert_full_chain.pem`
  - Private Key Passphrase
- Linode: `LINODE_CLI_PROD_TOKEN`
- GITLAB: `GL_PROD_API_KEY`
- GITHUB: `GH_PROD_API_TOKEN`
- Ansible Galaxy: `GALAXY_API_KEY`
- HashiCorp Terraform Cloud: `TF_PROD_TOKEN`
- Workspace Admin
  - Vault Auth - Google Workspace Details: `vault_gsuite_oidc_auth_configuration.json`

## [Create the server in Linode](tasks/100-create_server.yml)

## Artifacts

[GitLab info](ansible/vars/gitlab_artifacts.yml)

- Vault init secrets stored in gitlab CI/CD variables
- Terraform state stored in gitlab

## Vault Authentication - Google Workspace

[Developer Vault Documentation Auth Methods JWT/OIDC OIDC Providers Google](https://developer.hashicorp.com/vault/docs/auth/jwt/oidc-providers/google)
with change in Concent Screen User Type to Internal
[Also see](https://vagarwal2.medium.com/hashicorp-vault-groups-integration-with-google-g-suite-6df8951d7573)

- [Vault Auth Mount: `gsuite_admin`, Type JWT/OIDC.](codified_vault/auth/gsuite.tf)
- Work with a Google Workspace Super Admin User, AKA `gsuite_admin_impersonate`.
- Create a project in [Google Cloud Console](https://console.cloud.google.com).
- Enable [Admin SDK API](https://console.developers.google.com/apis/api/admin.googleapis.com/overview).
- Create a Service account: `xxxx-xxxxx@xxxxxxxx.iam.gserviceaccount.com`.
- Create a OAuth Client: `Hashicorp Vault`.
  - Redirect Uris
    - `<VAULT_ADDR>/ui/vault/auth/<AUTH_MOUNT_PATH>/oidc/callback`,
    - `http://localhost:8250/oidc/callback`.
- OAuth consent screen: `arpanrec production application authentication`. **User type: `Internal`
- [Domain-wide Delegation](https://admin.google.com/ac/owl/domainwidedelegation).
  - Add New -> Client id of Service account: `xxxx-xxxxx@xxxxxxxx.iam.gserviceaccount.com`, and below scopes.
    - `https://www.googleapis.com/auth/admin.directory.group.readonly`
    - `https://www.googleapis.com/auth/admin.directory.user.readonly`
- Create AD group in [Google Workspace](https://admin.google.com/ac/groups): `vault_admin`.
  - Create a email id for the group. *Likely to be auto created.

- Create json `vault_gsuite_oidc_auth_configuration.json` combining the above data.

```json
{
  "oauth_client": {
    "web": {
      "client_id": "000000000-xxxxxxxxxxxxx.apps.googleusercontent.com",
      "project_id": "xxxx-xxxx-xxxxxx",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
      "client_secret": "xxxxxx-xxxxxxxxxxxxxx",
      "redirect_uris": [
        "https://xxxxxxxxx:8200/ui/vault/auth/xxxxxxxxxx/oidc/callback",
        "http://localhost:8250/oidc/callback"
      ]
    }
  },
  "service_account": {
    "type": "service_account",
    "project_id": "xxxxx-xxxx-xxxx",
    "private_key_id": "xxxxxxxxxxxxxxxxxxx",
    "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkxxxxxxxxxx3MKey9ywXabd15oA=\n-----END PRIVATE KEY-----\n",
    "client_email": "xxxxxxx@xxxxxx-xxxxx-xxxxx.xxxx.gserviceaccount.com",
    "client_id": "xxxxxxxxxxxxxx",
    "auth_uri": "https://accounts.google.com/o/oauth2/auth",
    "token_uri": "https://oauth2.googleapis.com/token",
    "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
    "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/xxxxxx-xxxxx%xxxxxx-xxxx-xxxxx.iam.gserviceaccount.com"
  },
  "gsuite_admin_impersonate": "xxxxxx@xxxx.com",
  "gsuite_vault_admin_group_mail": "xxxxxxxx@xxxxxxxx.com"
}

```

# Vault Monolithic Repository

## Prerequisite: Download the below resources from [bitwarden](tasks/011-get_prerequisite.yml)

- OPENSSH KEY - SHA256:Nu4xUoniFGACilNjH9RB+3M1p4UoX8S71DVpPhZOBJ0
- CA ROOT - RSA PRIVATE KEY and CERTIFICATE - 16:73:5a:f9:ed:ae:aa:98:26:cb:cc:0c:f2:9b:29:ec:88:4c:4b:e9
- Linode
- GITLAB
- GITHUB
- Ansible Galaxy
- HashiCorp Terraform Cloud
- Vault Auth - Google Workspace Details

```json
{
    "oauth_client": "<OAuth Client Json Secret>",
    "service_account": "<Service Account Credentials Json>",
    "gsuite_admin_impersonate": "<Super Admin Email>",
    "gsuite_vault_admin_group_mail": "<Vault Admin Group Email>"
}
```

## [Create the server in Linode](tasks/100-create_server.yml)

## Artifacts

[GitLab info](ansible/vars/gitlab_artifacts.yml)

- Vault init secrets stored in gitlab CI/CD variables
- Terraform state stored in gitlab

## Vault Authentication - Google Workspace

[Developer Vault Documentation Auth Methods JWT/OIDC OIDC Providers Google](https://developer.hashicorp.com/vault/docs/auth/jwt/oidc-providers/google)
with change in Concent Screen User Type to Internal
[Also see](https://vagarwal2.medium.com/hashicorp-vault-groups-integration-with-google-g-suite-6df8951d7573)

- Vault Auth Mount: `gsuite_admin`, Type JWT/OIDC

- Create a project in [Google Cloud Console](https://console.cloud.google.com): `Master Production Applications`
- Enable [Admin SDK API](https://console.developers.google.com/apis/api/admin.googleapis.com/overview)
- Service account: `vault-admin@master-prod-apps.iam.gserviceaccount.com`
- OAuth Client ID: `Hashicorp Vault`
  - Redirect Uris
    - `<VAULT_ADDR>/ui/vault/auth/<AUTH_MOUNT_PATH>/oidc/callback`,
    - `http://localhost:8250/oidc/callback`
- OAuth consent screen: `arpanrec production application authentication` **User type: `Internal`
- [Domain-wide Delegation](https://admin.google.com/ac/owl/domainwidedelegation)
  - Add New -> Client id of `vault-admin@master-prod-apps.iam.gserviceaccount.com` and below scopes
    - `https://www.googleapis.com/auth/admin.directory.group.readonly`
    - `https://www.googleapis.com/auth/admin.directory.user.readonly`
- Create AD group in [Google Workspace](https://admin.google.com/ac/groups): `vault_admin` [mailto:vault_admin@arpanrec.com]

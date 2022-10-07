# Vault Monolithic Repository

Prerequisite: Download the below resources from [bitwarden](ansible/tasks/011-bw.yml)

- OPENSSH PRIVATE KEY - SHA256:fhklvyDcKCjO0LBqPLhgLyK4Y37sj9reXnYPh0QhsMA
- CA ROOT - RSA PRIVATE KEY and CERTIFICATE

- OPENSSH PRIVATE KEY - SHA256:5Q1+kxpJwCigjVOZEB02EYW5m/r6Bm4GRme90/0DkoI
- PGP PRIVATE KEY - B9A81CB849629C6341EC0AACD813A505EB696576

- Linode
- GITLAB
- GITHUB
- Ansible Galaxy
- HashiCorp Terraform cloud

## Artifacts

[GitLab info](ansible/vars/gitlab_artifacts.yml)

- Vault init secrets stored in gitlab CI/CD variables
- Terraform state stored in gitlab

# Vault Monolithic Repository

## Prerequisite: Download the below resources from [bitwarden](ansible/tasks/011-get_prerequisite.yml)

- OPENSSH KEY - SHA256:Nu4xUoniFGACilNjH9RB+3M1p4UoX8S71DVpPhZOBJ0
- CA ROOT - RSA PRIVATE KEY and CERTIFICATE - 16:73:5a:f9:ed:ae:aa:98:26:cb:cc:0c:f2:9b:29:ec:88:4c:4b:e9
- Linode
- GITLAB
- GITHUB
- Ansible Galaxy
- HashiCorp Terraform cloud

## [Create the server in Linode](ansible/tasks/100-create_server.yml)

## Artifacts

[GitLab info](ansible/vars/gitlab_artifacts.yml)

- Vault init secrets stored in gitlab CI/CD variables
- Terraform state stored in gitlab

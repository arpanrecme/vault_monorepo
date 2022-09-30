#!/bin/bash
set -e

## Get Bitwarden Info
__bw_organization_name='Password Organization'
__bw_organization_collection_name='arpanrec/gitlab_master_control'

__bw_organization_id=$(bw list organizations --raw | jq --arg BW_ORG_NAME "$__bw_organization_name" \
    '.[] | select(.name == $BW_ORG_NAME) | .id' -r)

__bw_organization_collection_id=$(bw list org-collections --organizationid "${__bw_organization_id}" --raw | jq \
    --arg BW_ORG_COLL_NAME "$__bw_organization_collection_name" '.[] | select(.name == $BW_ORG_COLL_NAME) | .id' -r)

__bw_all_items_list=$(bw list items --organizationid "${__bw_organization_collection_id}" \
    --collectionid "${__bw_organization_collection_id}" --raw)

## Accounts

__gh_prod_api_token=$(echo "${__bw_all_items_list}" | jq '.[] | select(.name == "Github - arpanrec") | .fields |
    .[] | select(.name == "GH_PROD_API_TOKEN") | .value' -r)

__gl_prod_api_key=$(echo "${__bw_all_items_list}" | jq '.[] | select(.name == "GitLab - arpanrec") | .fields |
    .[] | select(.name == "GL_PROD_API_KEY") | .value' -r)

__galaxy_api_key=$(echo "${__bw_all_items_list}" | jq '.[] | select(.name == "Ansible galaxy") | .fields |
    .[] | select(.name == "GALAXY_API_KEY") | .value' -r)

__tf_prod_token=$(echo "${__bw_all_items_list}" | jq '.[] | select(.name == "HashiCorp Terraform cloud - arpanrec") | .fields |
    .[] | select(.name == "TF_PROD_TOKEN") | .value' -r)

__linode_cli_prod_token=$(echo "${__bw_all_items_list}" | jq '.[] | select(.name == "Linode - arpanr") | .fields |
    .[] | select(.name == "LINODE_CLI_PROD_TOKEN") | .value' -r)

## Keys
### PGP PRIVATE KEY - B9A81CB849629C6341EC0AACD813A505EB696576

__bw_pgp_private_key_item=$(echo "${__bw_all_items_list}" | jq '.[] |
    select(.name == "PGP PRIVATE KEY - B9A81CB849629C6341EC0AACD813A505EB696576")' -r)

__bw_pgp_private_key_item_id=$(echo "${__bw_pgp_private_key_item}" | jq -r .id)

__openpgp_private_key="$(bw get attachment B9A81CB849629C6341EC0AACD813A505EB696576.asc \
    --itemid "${__bw_pgp_private_key_item_id}" --raw)"

__openpgp_private_key_password="$(bw get password B9A81CB849629C6341EC0AACD813A505EB696576)"

echo "${__openpgp_private_key}" | gpg \
    --allow-secret-key-import --import --batch --passphrase "${__openpgp_private_key_password}" &>/dev/null

__openpgp_public_key="$(gpg --armor --export B9A81CB849629C6341EC0AACD813A505EB696576)"

### OPENSSH PRIVATE KEY - 41:13:da:7b:a2:fd:c5:b2:f2:71:21:ed:0f:a3:c3:a8

__bw_openssh_private_key_item=$(echo "${__bw_all_items_list}" | jq '.[] |
    select(.name == "OPENSSH PRIVATE KEY - 41:13:da:7b:a2:fd:c5:b2:f2:71:21:ed:0f:a3:c3:a8")' -r)

__openssh_private_key=$(echo "${__bw_openssh_private_key_item}" | jq .notes -r)

echo "${__openssh_private_key}" >openssh_4113da7ba2fdc5b2f27121ed0fa3c3a8

chmod 600 openssh_4113da7ba2fdc5b2f27121ed0fa3c3a8

__openssh_private_key_passphrase=$(echo \
    "${__bw_openssh_private_key_item}" |
    jq '.fields | .[] | select(.name == "passphrase") | .value' -r)

__openssh_public_key=$(ssh-keygen -y -P "${__openssh_private_key_passphrase}" \
    -f openssh_4113da7ba2fdc5b2f27121ed0fa3c3a8 || true)

rm -rf openssh_4113da7ba2fdc5b2f27121ed0fa3c3a8

### RSA PRIVATE KEY - arpanrec ROOT CA V1

__bw_rsa_private_key_item=$(echo "${__bw_all_items_list}" | jq '.[] |
    select(.name == "RSA PRIVATE KEY - arpanrec ROOT CA V1")' -r)

__rsa_private_key=$(echo "${__bw_rsa_private_key_item}" | jq .notes -r)

__rsa_private_key_passphrase=$(echo \
    "${__bw_rsa_private_key_item}" |
    jq '.fields | .[] | select(.name == "passphrase") | .value' -r)

### CERTIFICATE - arpanrec ROOT CA V1

__bw_root_certificate_item=$(echo "${__bw_all_items_list}" | jq '.[] |
    select(.name == "CERTIFICATE - arpanrec ROOT CA V1")' -r)

__root_certificate=$(echo "${__bw_root_certificate_item}" | jq .notes -r)

## Create JSON and Write to file

###  Why line break in some variables, like OPENPGP_PRIVATE_KEY?? https://askubuntu.com/questions/121866/why-does-bash-remove-n-in-cat-file
jq --null-input -r \
    --arg GH_PROD_API_TOKEN "${__gh_prod_api_token}" \
    --arg GL_PROD_API_KEY "${__gl_prod_api_key}" \
    --arg GALAXY_API_KEY "${__galaxy_api_key}" \
    --arg TF_PROD_TOKEN "${__tf_prod_token}" \
    --arg OPENPGP_PRIVATE_KEY "${__openpgp_private_key}"'
' \
    --arg OPENPGP_PRIVATE_KEY_PASSWORD "${__openpgp_private_key_password}" \
    --arg OPENPGP_PUBLIC_KEY "${__openpgp_public_key}"'
' \
    --arg OPENSSH_PRIVATE_KEY "${__openssh_private_key}"'
' \
    --arg OPENSSH_PRIVATE_KEY_PASSPHRASE "${__openssh_private_key_passphrase}" \
    --arg OPENSSH_PUBLIC_KEY "${__openssh_public_key}" \
    --arg LINODE_CLI_PROD_TOKEN "${__linode_cli_prod_token}" \
    --arg RSA_PRIVATE_KEY "${__rsa_private_key}"'
' \
    --arg RSA_PRIVATE_KEY_PASSPHRASE "${__rsa_private_key_passphrase}" \
    --arg ROOT_CERTIFICATE "${__root_certificate}"'
' \
    '.
    + {GH_PROD_API_TOKEN: $GH_PROD_API_TOKEN}
    + {GL_PROD_API_KEY: $GL_PROD_API_KEY}
    + {GALAXY_API_KEY: $GALAXY_API_KEY}
    + {TF_PROD_TOKEN: $TF_PROD_TOKEN}
    + {OPENPGP_PRIVATE_KEY: $OPENPGP_PRIVATE_KEY}
    + {OPENPGP_PRIVATE_KEY_PASSWORD: $OPENPGP_PRIVATE_KEY_PASSWORD}
    + {OPENPGP_PUBLIC_KEY: $OPENPGP_PUBLIC_KEY}
    + {OPENSSH_PRIVATE_KEY: $OPENSSH_PRIVATE_KEY}
    + {OPENSSH_PRIVATE_KEY_PASSPHRASE: $OPENSSH_PRIVATE_KEY_PASSPHRASE}
    + {OPENSSH_PUBLIC_KEY: $OPENSSH_PUBLIC_KEY}
    + {LINODE_CLI_PROD_TOKEN: $LINODE_CLI_PROD_TOKEN}
    + {RSA_PRIVATE_KEY: $RSA_PRIVATE_KEY}
    + {RSA_PRIVATE_KEY_PASSPHRASE: $RSA_PRIVATE_KEY_PASSPHRASE}
    + {ROOT_CERTIFICATE: $ROOT_CERTIFICATE}
    '

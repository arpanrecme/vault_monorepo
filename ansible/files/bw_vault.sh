#!/bin/bash
set -e

__vault_init_secrets_file=$1

if [ -z "${__vault_init_secrets_file}" ]; then
    echo "Missing init secret content"
    exit 1
fi

__vault_init_secrets=$(cat "${__vault_init_secrets_file}")

## Get Bitwarden Info
__bw_organization_name='Password Organization'
__bw_organization_collection_name='arpanrec/gitlab_master_control'
__bw_item_name='Vault - vault.arpanrec.com'
__bw_organization_id=$(bw list organizations --raw | jq --arg BW_ORG_NAME "$__bw_organization_name" \
    '.[] | select(.name == $BW_ORG_NAME) | .id' -r)

__bw_organization_collection_id=$(bw list org-collections --organizationid "${__bw_organization_id}" --raw | jq \
    --arg BW_ORG_COLL_NAME "$__bw_organization_collection_name" '.[] | select(.name == $BW_ORG_COLL_NAME) | .id' -r)

__bw_item=$(bw get item "${__bw_item_name}" --raw || true)

if [ -z "${__bw_item}" ]; then
    __bw_new_item=$(
        bw get template item | jq \
            --arg ORGANIZATION_ID "${__bw_organization_collection_id}" \
            --arg COLLECTION_ID "${__bw_organization_collection_id}" \
            --arg VAULT_INIT_SECRET "${__vault_init_secrets}" \
            --arg VAULT_INIT_SECRET_ITEM_NAME "${__bw_item_name}" \
            '.type = 2 | .secureNote.type = 0
    | .notes = $VAULT_INIT_SECRET
    | .organizationId = $ORGANIZATION_ID
    | .collectionIds = [$COLLECTION_ID]
    | .name = $VAULT_INIT_SECRET_ITEM_NAME'
    )
    echo "${__bw_new_item}" | bw encode | bw create item
else
    __bw_item_id=$(echo "${__bw_item}" | jq .id -r)

    echo "${__bw_item}" |
        jq --arg VAULT_INIT_SECRET "${__vault_init_secrets}" '.notes=$VAULT_INIT_SECRET' |
        bw encode |
        bw edit item "${__bw_item_id}"
fi

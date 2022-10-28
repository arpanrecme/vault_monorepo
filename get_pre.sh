#!/bin/bash

__vault_mono_prerequisite_files_dir=${VAULT_MONO_PREREQUISITE_FILES_DIR:-./.tmp}

mkdir -p "${__vault_mono_prerequisite_files_dir}"

__vault_mono_local_file_openssh_private_key=${__vault_mono_prerequisite_files_dir}/secrets.openssh_rsa_id.key
__vault_mono_local_file_openssh_public_key=${__vault_mono_prerequisite_files_dir}/openssh_rsa_id.key.pub
__vault_mono_local_file_openssh_private_key_passphrase=${__vault_mono_prerequisite_files_dir}/secrets.openssh_rsa_id_passphrase.txt

bw get attachment id_rsa \
    --itemid "$(bw get item 'Nu4xUoniFGACilNjH9RB+3M1p4UoX8S71DVpPhZOBJ0' \
        --raw | jq .id -r)" \
    --output "${__vault_mono_local_file_openssh_private_key}"

chmod 400 "${__vault_mono_local_file_openssh_private_key}"

bw get attachment id_rsa.pub \
    --itemid "$(bw get item 'Nu4xUoniFGACilNjH9RB+3M1p4UoX8S71DVpPhZOBJ0' \
        --raw | jq .id -r)" \
    --output "${__vault_mono_local_file_openssh_public_key}"
chmod 400 "${__vault_mono_local_file_openssh_public_key}"

bw get password 'Nu4xUoniFGACilNjH9RB+3M1p4UoX8S71DVpPhZOBJ0' >"${__vault_mono_local_file_openssh_private_key_passphrase}"

vault_mono_local_file_linode_cli_prod_token=${__vault_mono_prerequisite_files_dir}/secrets.linode_cli_prod_token.txt

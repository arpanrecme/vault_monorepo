MINIO_ROOT_USER={{ lookup('community.general.random_string', base64=True, min_lower=1, min_upper=1, min_special=0, min_numeric=1, length=12) }}
MINIO_ROOT_PASSWORD={{ lookup('community.general.random_string', base64=True, min_lower=1, min_upper=1, min_special=1, min_numeric=1, length=48) }}
MINIO_VOLUMES="{{ vault_mono_server_minio_volumes }}"
MINIO_OPTS="--certs-dir {{ vault_mono_server_minio_certs_dir }} \
    --address :{{ vault_mono_global_config.S3.SERVER_PORT }} \
    --console-address :{{ vault_mono_global_config.S3.MINIO_CONSOLE_PORT }}"
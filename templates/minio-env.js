MINIO_ROOT_USER={{ lookup('community.general.random_string', base64=True, min_lower=1, min_upper=1, min_special=0, min_numeric=1, length=12) }}
MINIO_ROOT_PASSWORD={{ lookup('community.general.random_string', base64=True, min_lower=1, min_upper=1, min_special=1, min_numeric=1, length=12) }}
MINIO_ACCESS_KEY={{ lookup('community.general.random_string', base64=True, min_lower=1, min_upper=1, min_special=0, min_numeric=1, length=12) }}
MINIO_SECRET_KEY={{ lookup('community.general.random_string', base64=True, min_lower=1, min_upper=1, min_special=1, min_numeric=1, length=12) }}
MINIO_VOLUMES="{{ vault_mono_server_minio_dir }}"

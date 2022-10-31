#!/usr/bin/python3

import json
import os
import time
import hvac
from prettytable import PrettyTable

global_config = json.load(open('files/config.json', encoding="utf-8"))
VAULT_ADDR = f"https://{global_config.get('VAULT_ADDR_DOMAIN_NAME')}:{global_config.get('VAULT_ADDR_PORT')}"
VAULT_CLIENT_CERT = ".tmp/mutual_tls_certs/client_certificate.crt"
VAULT_CLIENT_KEY = ".tmp/mutual_tls_certs/secrets.client_private_key.key"
VAULT_CA_PATH = ".tmp/prerequisite/root_ca_certificate.crt"

client = hvac.Client(
    url=VAULT_ADDR,
    token=os.environ["TF_VAR_VAULT_MONO_VAULT_ROOT_TOKEN"],
    cert=(VAULT_CLIENT_CERT, VAULT_CLIENT_KEY),
    verify=VAULT_CA_PATH,
)
current_accessor = client.auth.token.lookup_self().get('data').get('accessor')
payload = client.list('auth/token/accessors')
keys = payload['data']['keys']
pretty_table = PrettyTable()
pretty_table.field_names = ["Display Name",
                            "Creation Time",
                            "Expiration Time",
                            "Policies",
                            "Token Accessor",
                            "Revoked"]

for key in keys:
    output = client.lookup_token(key, accessor=True)
    display_name = output['data']['display_name']
    creation_date = time.strftime('%Y-%m-%d %H:%M:%S',
                                  time.localtime(output['data']['creation_time']))
    expire_time = output['data']['expire_time']
    policies = output['data']['policies']
    accessor = key
    REVOKED = False
    if accessor != current_accessor:
        client.revoke_token(accessor, accessor=True)
        REVOKED = True
        # if "root" in policies:
        pretty_table.add_row([display_name,
                              creation_date,
                              expire_time,
                              policies,
                              accessor,
                              REVOKED])
print(pretty_table)

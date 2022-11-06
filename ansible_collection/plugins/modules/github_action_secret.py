#!/usr/bin/python

# Copyright: (c) 2022, Arpan Mandal <arpan.rec@gmail.com>
# MIT (see LICENSE or https://en.wikipedia.org/wiki/MIT_License)
from __future__ import (absolute_import, division, print_function)
import os
from ansible.module_utils.basic import AnsibleModule
from base64 import b64encode
from nacl import encoding, public
import requests
__metaclass__ = type


DOCUMENTATION = r'''
---
module: github_action_secret

short_description: Create Update Delete Github Action Secret

version_added: "1.0.0"

description: Create Update Delete Github Action Secret.

options:
    api_ep:
        description: Rest Api endpoint
        required: false
        type: str
        default: "https://api.github.com"
    pat:
        description: Github PAT.
        required: true
        type: str
    owner:
        description: Owner Of the repository
        required: false
        type: str
    unencrypted_secret:
        description: Plain text action secret
        required: false
        type: str
    name:
        description: Name of the secret
        required: true
        type: str
    repository:
        description: Plain text action secret
        required: false
        type: str
author:
    - Arpan Mandal (mailto:arpan.rec@gmail.com)
'''

EXAMPLES = r'''
# Pass in a message
- name: Create or Update a secret
  github_action_secret:
    pat:
        [
        "xxxxx",
        "yyyyy",
        "zzzzz",
        ]
    owner: https://vault.com:8200
    unencrypted_secret: "vault_client_auth.crt"
    repository: "vault_client_auth.key"
    vault_capath: "root_ca_certificate.crt"
'''

RETURN = r'''
# These are examples of possible return values, and in general should use other names for return values.
# encoded_root_token:
#     description: Base64 ascii encoded root token
#     type: str
#     returned: always
# otp:
#     description: OTP
#     type: str
#     returned: always
# new_root:
#     description: ((OTP bytes) XOR (base64 ascii decode of encoded_root_token))
#     type: str
#     returned: if calculate_new_root
'''


def encrypt(public_key: str, secret_value: str) -> str:
    """Encrypt a Unicode string using the public key."""
    public_key = public.PublicKey(public_key.encode("utf-8"), encoding.Base64Encoder())
    sealed_box = public.SealedBox(public_key)
    encrypted = sealed_box.encrypt(secret_value.encode("utf-8"))
    return b64encode(encrypted).decode("utf-8")


def crud(pat=None, owner=None, unencrypted_secret=None, name=None, repository=None, api_ep=None, secret=None) -> dict:
    result = {"changed": True}
    headers = {
        "Accept": "application/vnd.github+json",
        "Authorization": f"token {pat}"
    }
    if owner:
        public_key_ep = f"{api_ep}/repos/{owner}/{repository}/actions/secrets/public-key"

    public_key_ep_res = requests.get(public_key_ep, headers=headers, timeout=30).json()
    result["public_key"] = public_key_ep_res.get("key")
    result["public_key_id"] = public_key_ep_res.get("key_id")

    if unencrypted_secret:
        secret = encrypt(public_key=result["public_key"], secret_value=unencrypted_secret)
    result["secret"] = secret

    secret_ep = f"{api_ep}/repos/{owner}/{repository}/actions/secrets/{name}"
    update_data = {"encrypted_value": result["secret"], "key_id": result["public_key_id"]}
    secret_ep_response = requests.put(secret_ep, headers=headers, timeout=30, json=update_data)
    if secret_ep_response.status_code == 204:
        result["updated"] = True
        result["created"] = False
    if secret_ep_response.status_code == 201:
        result["updated"] = False
        result["created"] = True
    return {"result": result}


def run_module():
    # define available arguments/parameters a user can pass to the module
    module_args = dict(
        api_ep=dict(type="str", required=False, default="https://api.github.com"),
        pat=dict(type='str', required=True, no_log=True),
        owner=dict(type='str', required=False),
        unencrypted_secret=dict(type='str', required=False, no_log=True),
        name=dict(type='str', required=True),
        repository=dict(type='str', required=False),
    )

    module = AnsibleModule(
        argument_spec=module_args,
        supports_check_mode=False,
    )

    root_gen_result = crud(api_ep=module.params['api_ep'],
                           pat=module.params['pat'],
                           owner=module.params['owner'],
                           unencrypted_secret=module.params['unencrypted_secret'],
                           name=module.params['name'],
                           repository=module.params['repository'],
                           )

    if "error" in root_gen_result.keys():
        return module.fail_json(msg=root_gen_result["error"], **root_gen_result["result"])

    module.exit_json(**root_gen_result['result'])


def main():
    run_module()


if __name__ == '__main__':
    res = crud(pat=os.getenv("GH_PROD_API_TOKEN"), owner="arpanrecme", unencrypted_secret="abc",
               name="abc11", repository="github_master_controller", api_ep="https://api.github.com")
    import json
    print(json.dumps(res, indent=2))

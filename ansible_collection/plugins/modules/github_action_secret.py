#!/usr/bin/env python3

# Copyright: (c) 2022, Arpan Mandal <arpan.rec@gmail.com>
# MIT (see LICENSE or https://en.wikipedia.org/wiki/MIT_License)
from __future__ import (absolute_import, division, print_function)
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
        description:
            - Owner Of the repository
            - When organization and owner both are missing, this value will be set as the owner of PAT
            - mutually exclusive with organization
        required: false
        type: str
    organization:
        description:
            - organization of the repository
            - If repository is missing then the secret wil be added to organization secret
    unencrypted_secret:
        description: Plain text action secret
        required: false
        type: str
    secret:
        description: libsodiam encrypted action secret
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
    state:
        description: State of the secret.
        required: false
        type: enum[present, absent]
        default: present
    visibility:
        description:
            - Required for organization secrets
            - `private`, `all`, `selected`
        type: enum[private, all, selected]
        default: "all"
        required: false
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


def crud(pat=None, owner=None, unencrypted_secret=None, name=None, repository=None, api_ep=None, secret=None, organization=None, state=None, visibility=None) -> dict:
    result = {"changed": False, "updated": False, "created": False, "deleted": False}
    create_update_data = {}
    headers = {
        "Accept": "application/vnd.github+json",
        "Authorization": f"token {pat}"
    }
    if owner and not repository:
        return {"error": "'repository' is mandatory when 'owner' is set", "result": result}

    if state not in ["present", "absent"]:
        return {"error": "state should be either present or absent", "result": result}

    if (not owner) and (not repository) and (organization) \
            and visibility not in ['private', 'all', 'selected']:
        return {"error": "visibility should in 'private', 'all', 'selected'",
                "result": result}

    if owner and repository:
        public_key_ep = f"{api_ep}/repos/{owner}/{repository}/actions/secrets/public-key"
        secret_ep = f"{api_ep}/repos/{owner}/{repository}/actions/secrets/{name}"
    elif (not owner) and (repository) and (not organization):
        owner = requests.get(f"{api_ep}/user", headers=headers, timeout=30).json()['login']
        public_key_ep = f"{api_ep}/repos/{owner}/{repository}/actions/secrets/public-key"
        secret_ep = f"{api_ep}/repos/{owner}/{repository}/actions/secrets/{name}"
    elif (not owner) and (not repository) and (organization):
        public_key_ep = f"{api_ep}/orgs/{organization}/actions/secrets/public-key"
        secret_ep = f"{api_ep}/orgs/{organization}/actions/secrets/{name}"
        create_update_data["visibility"] = visibility
    elif (not owner) and (repository) and (organization):
        public_key_ep = f"{api_ep}/repos/{organization}/{repository}/actions/secrets/public-key"
        secret_ep = f"{api_ep}/repos/{organization}/{repository}/actions/secrets/{name}"

    if state == 'present':
        public_key_ep_res = requests.get(public_key_ep, headers=headers, timeout=30).json()
        result["public_key"] = public_key_ep_res.get("key")
        result["public_key_id"] = public_key_ep_res.get("key_id")
        if unencrypted_secret:
            secret = encrypt(public_key=result["public_key"], secret_value=unencrypted_secret)
        result["secret"] = secret
        create_update_data["encrypted_value"] = secret
        create_update_data["key_id"] = result["public_key_id"]
        secret_ep_response = requests.put(secret_ep,
                                          headers=headers,
                                          timeout=30,
                                          json=create_update_data)
        if secret_ep_response.status_code == 204:
            result["updated"] = True
            result["changed"] = True
        elif secret_ep_response.status_code == 201:
            result["changed"] = True
            result["created"] = True
        else:
            return {"error": {"response": secret_ep_response.json(),
                              "status": secret_ep_response.status_code},
                    "result": result}
    if state == 'absent':
        delete_response = requests.delete(secret_ep, headers=headers, timeout=30)
        if delete_response.status_code == 204:
            result["changed"] = True
            result["deleted"] = True
        elif delete_response.status_code == 404:
            pass
        else:
            return {"error": {"response": delete_response.json(),
                              "status": delete_response.status_code},
                    "result": result}
    return {"result": result}


def run_module():
    # define available arguments/parameters a user can pass to the module
    module_args = dict(
        api_ep=dict(type="str", required=False, default="https://api.github.com"),
        pat=dict(type='str', required=True, no_log=True),
        owner=dict(type='str', required=False),
        organization=dict(type='str', required=False),
        unencrypted_secret=dict(type='str', required=False, no_log=True),
        secret=dict(type="str", required=False, no_log=True),
        name=dict(type='str', required=True),
        repository=dict(type='str', required=False),
        state=dict(type="str", required=False, default="present"),
        visibility=dict(type="str", required=False, default="all")
    )

    module = AnsibleModule(
        argument_spec=module_args,
        supports_check_mode=False,
        mutually_exclusive=[
            ('owner', 'organization'),
            ('unencrypted_secret', 'secret')
        ],
        required_one_of=[
            ('repository', 'organization'),
        ],
        required_if=[
            ('state', 'present', ('unencrypted_secret', 'secret'), True),
        ],
    )

    github_update_response = crud(api_ep=module.params['api_ep'],
                                  pat=module.params['pat'],
                                  owner=module.params['owner'],
                                  unencrypted_secret=module.params['unencrypted_secret'],
                                  name=module.params['name'],
                                  repository=module.params['repository'],
                                  )

    if "error" in github_update_response.keys():
        return module.fail_json(msg=github_update_response["error"],
                                **github_update_response["result"])

    module.exit_json(**github_update_response['result'])


def main():
    run_module()


if __name__ == '__main__':
    main()

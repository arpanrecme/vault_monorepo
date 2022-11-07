#!/usr/bin/python

# Copyright: (c) 2022, Arpan Mandal <arpan.rec@gmail.com>
# MIT (see LICENSE or https://en.wikipedia.org/wiki/MIT_License)
from __future__ import (absolute_import, division, print_function)
from ansible.module_utils.basic import AnsibleModule
import requests
__metaclass__ = type


DOCUMENTATION = r'''
---
module: github_action_secret

short_description: Create Update Delete Github Action Secret

version_added: "1.0.0"

description: Create Update Delete Github Action Secret.

options:
    hostname:
        description: Terraform Cloud Hostname.
        required: false
        type: str
        default: app.terraform.io
    token:
        description: Terraform Cloud Access Token.
        required: true
        type: str
    organization:
        description: Name of terraform cloud organization
        required: true
        type: str
    organization_attributes:
        description: Attributes of terraform cloud organization
        required: false
        type: dict
    workspace_name:
        description: Name of terraform workspace
        required: true
        type: str
    workspace_auto_apply:
        description: If -auto-approve is applied then state will be applied via the remote
        required: false
        type: bool
    execution_mode:
        description:
            - Which execution mode to use.
            - Valid values are remote, local, and agent.
            - When set to local, the workspace will be used for state storage only.
            - This value must not be specified if operations is specified.
        required: false
        type: str
        choices: ["remote", "local", "agent"]
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


def crud(hostname=None, token=None, organization=None, organization_attributes=None, workspace_name=None) -> dict:
    result = {"changed": False, "organization_updated": False, "organization_created": False}
    headers = {
        "Accept": "application/vnd.github+json",
        "content-type": "application/vnd.api+json",
        "Authorization": f"Bearer {token}"
    }
    if not hostname:
        return {"error": "Hostname Can not be null", "result": result}
    if not organization:
        return {"error": "organization Can not be null", "result": result}
    if not workspace_name:
        return {"error": "workspace_name Can not be null", "result": result}

    _tfe_org_ep = f"https://{hostname}/api/v2/organizations/{organization}"
    _tfe_existing_org_details_response = requests.get(_tfe_org_ep, timeout=30, headers=headers)

    if _tfe_existing_org_details_response.status_code == 200:
        _tfe_org_details = _tfe_existing_org_details_response.json()
    elif _tfe_existing_org_details_response.status_code == 404:
        _org_create_data = {
            "data": {
                "type": "organizations",
                "attributes": {}
            }
        }
        if organization_attributes and len(organization_attributes) > 0:
            _org_create_data["data"]["attributes"] = organization_attributes
        _org_create_data["data"]["attributes"]["name"] = organization
        _tfe_org_create_response = requests.post(f"https://{hostname}/api/v2/organizations", timeout=30, headers=headers, json=_org_create_data)
        if _tfe_org_create_response.status_code == 201:
            result["changed"] = True
            result["organization_created"] = True
            _tfe_newly_created_org_details_response = requests.get(_tfe_org_ep, timeout=30, headers=headers)
            if _tfe_newly_created_org_details_response.status_code == 200:
                _tfe_org_details = _tfe_newly_created_org_details_response.json()
            else:
                result["error"] = {"status": _tfe_newly_created_org_details_response.status_code, "msg": _tfe_newly_created_org_details_response.json()}
                return result
        else:
            result["error"] = {"status": _tfe_org_create_response.status_code, "msg": _tfe_org_create_response.json()}
            return result
    else:
        result["error"] = {"status": _tfe_existing_org_details_response.status_code, "msg": _tfe_existing_org_details_response.json()}
        return result

    if not result["organization_created"]:
        if organization_attributes and len(organization_attributes) > 0:
            _existing_attributes = _tfe_org_details["data"]["attributes"]
            for attribute in organization_attributes.keys():
                if organization_attributes[attribute] != _existing_attributes[attribute]:
                    _org_update_data = {
                        "data": {
                            "type": "organizations",
                            "attributes": organization_attributes
                        }
                    }
                    _org_update_response = requests.patch(_tfe_org_ep, timeout=30, headers=headers, json=_org_update_data)
                    if _org_update_response.status_code == 200:
                        result["changed"] = True
                        result["organization_updated"] = True
                        _tfe_org_updated_details_response = requests.get(_tfe_org_ep, timeout=30, headers=headers)
                        if _tfe_org_updated_details_response.status_code == 200:
                            _tfe_org_details = _tfe_org_updated_details_response.json()
                        else:
                            result["error"] = {"status": _tfe_org_updated_details_response.status_code, "msg": _tfe_org_updated_details_response.json()}
                            return result
                        break

                    result["error"] = {"status": _org_update_response.status_code, "msg": _org_update_response.json()}
                    return result
    result["organization"] = _tfe_org_details
    return result


def run_module():
    # define available arguments/parameters a user can pass to the module
    module_args = dict(
        hostname=dict(required=False, default="app.terraform.io"),
        token=dict(type="str", required=True, no_log=True),
        organization=dict(type='str', required=True),
        organization_attributes=dict(type='dict', required=False),
        workspace_name=dict(type="str", required=True),
        workspace_auto_apply=dict(type='str', required=False),
        execution_mode=dict(type="str", required=False),
    )

    module = AnsibleModule(
        argument_spec=module_args,
        supports_check_mode=False,
    )

    tfe_response = crud(hostname=module.params['hostname'],
                        token=module.params['token'],
                        organization=module.params['organization'],
                        organization_attributes=module.params['organization_attributes'],
                        workspace_name=module.params['workspace_name'],
                        )

    if "error" in tfe_response.keys():
        return module.fail_json(msg=tfe_response["error"],
                                **tfe_response["result"])

    module.exit_json(**tfe_response['result'])


def main():
    run_module()


# if __name__ == '__main__':
#     main()

if __name__ == "__main__":
    import os
    import json
    res = crud(
        hostname="app.terraform.io",
        token=os.getenv("TF_PROD_TOKEN"),
        organization="arpanrecme11",
        workspace_name="testmod1",
        organization_attributes={
            "email": "afasf@gmail.com",
            "collaborator-auth-policy": "two_factor_mandatory"
        }
    )
    print(json.dumps(res, indent=2))

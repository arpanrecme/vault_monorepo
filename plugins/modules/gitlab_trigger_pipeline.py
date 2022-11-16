"""
Ansible Plugin Script
"""
#!/usr/bin/env python3

# Copyright: (c) 2022, Arpan Mandal <arpan.rec@gmail.com>
# MIT (see LICENSE or https://en.wikipedia.org/wiki/MIT_License)
from __future__ import absolute_import, division, print_function

import urllib.parse
import requests
from ansible.module_utils.basic import AnsibleModule
__metaclass__ = type


DOCUMENTATION = r'''
---
module: gitlab_trigger_pipeline

short_description: Trigger Gitlab Pipeline

version_added: "1.0.0"

description: Trigger Gitlab Pipeline.

options:
    api_ep:
        description: Rest Api endpoint
        required: false
        type: str
        default: "https://gitlab.com"
    private_token:
        description: Gitlab Private Token.
        required: false
        type: str
    token:
        description: The trigger token or CI/CD job token.
        required: false
        type: str
    project_id:
        description: The ID or URL-encoded path of the project owned by the authenticated user.
    ref:
        description:
            - The branch or tag to run the pipeline on.
            - Defaults to the default branch of repo
        required: false
        type: str
author:
    - Arpan Mandal (mailto:arpan.rec@gmail.com)
'''


def crud(
        api_ep=None,
        private_token=None,
        token=None,
        project_id=None,
        ref=None,
) -> dict:
    """
    Gitlab Trigger pipeline implementation
    """
    result = {"changed": False, "token_created": False}
    _token_description = "gitlab_trigger_pipeline_tmp"

    if not api_ep:
        raise Exception("Missing API Endpoint")

    if not private_token and not token:
        raise Exception("private_token or token is required")

    if private_token and token and ref:
        raise Exception("private_token and token are mutually exclusive when ref is present")

    if not project_id:
        raise Exception("project_id is mandatory")

    if not private_token and not ref:
        raise Exception("private_token is mandatory when ref is not present")

    project_id = urllib.parse.quote(project_id.encode("utf-8"),  safe='').strip()

    if not token:
        head = {
            "PRIVATE-TOKEN": private_token
        }
        trigger_url = f"{api_ep}/api/v4/projects/{project_id}/triggers"
        list_of_trigger_token_response = requests.get(trigger_url, timeout=30, headers=head)
        if list_of_trigger_token_response.status_code == 200:
            _if_token_exists = False
            for token_details in list_of_trigger_token_response.json():
                if token_details["description"] == _token_description:
                    _token_details = token_details
                    _if_token_exists = True
                    break
            if not _if_token_exists:
                params = {
                    "description": _token_description,
                }
                new_trigger_token_response = requests.post(
                    trigger_url,
                    timeout=30,
                    headers=head,
                    params=params
                )
                if new_trigger_token_response.status_code == 201:
                    result["changed"] = True
                    result["token_created"] = True
                    _token_details = (new_trigger_token_response.json())
                else:
                    raise Exception({
                        "msg": new_trigger_token_response.json(),
                        "status_code": new_trigger_token_response.status_code
                    })
        else:
            raise Exception({
                "msg": list_of_trigger_token_response.json(),
                "status_code": list_of_trigger_token_response.status_code
            })
        token = _token_details["token"]
    result["token"] = token

    if not ref:
        head = {
            "PRIVATE-TOKEN": private_token
        }
        ref_url = f"{api_ep}/api/v4/projects/{project_id}"
        ref_details_res = requests.get(ref_url, timeout=30, headers=head)
        if ref_details_res.status_code == 200:
            ref = ref_details_res.json().get("default_branch")
        else:
            raise Exception({
                "msg": ref_details_res.json(),
                "status_code": ref_details_res.status_code
            })

    result["ref"] = ref

    trigger_pipeline_url = f"{api_ep}/api/v4/projects/{project_id}/trigger/pipeline"
    params = {
        "ref": ref,
        "token": token
    }
    trigger_pipeline_details_res = requests.post(trigger_pipeline_url, params=params, timeout=30)
    if trigger_pipeline_details_res.status_code == 201:
        result["run_details"] = trigger_pipeline_details_res.json()
        result["changed"] = True
    elif trigger_pipeline_details_res.status_code == 400:
        _ci_missing = trigger_pipeline_details_res.json()
        if _ci_missing["message"]["base"][0] == "Missing CI config file":
            result["run_details"] = _ci_missing["message"]
        else:
            raise Exception({
                "msg": _ci_missing,
                "status_code": 400
            })
    else:
        raise Exception({
            "msg": trigger_pipeline_details_res.json(),
            "status_code": trigger_pipeline_details_res.status_code
        })
    return result


def run_module() -> None:
    """
    Ansible run module
    """
    module_args = dict(
        api_ep=dict(type="str", required=False, default="https://gitlab.com"),
        private_token=dict(type='str', required=False, no_log=True),
        token=dict(type='str', required=False, no_log=True),
        project_id=dict(type='str', required=True),
        ref=dict(type='str', required=False),
    )

    module = AnsibleModule(
        argument_spec=module_args,
        supports_check_mode=False
    )

    try:
        gitlab_pipe_response = crud(
            api_ep=module.params['api_ep'],
            private_token=module.params['private_token'],
            token=module.params['token'],
            project_id=module.params['project_id'],
            ref=module.params['ref'],
        )
    except BaseException as ex:
        module.fail_json(msg=ex)
    module.exit_json(**gitlab_pipe_response)


# if __name__ == '__main__':
#     import os
#     import json
#     res = crud(
#         api_ep="https://gitlab.com",
#         private_token=os.getenv("GL_PROD_API_KEY"),
#         project_id="arpanrecme/test",
#     )

#     print(json.dumps(res, indent=4))

def main():
    run_module()


if __name__ == '__main__':
    main()

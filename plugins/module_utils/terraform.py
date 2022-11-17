import requests


def tfe_org(hostname=None, headers=None, organization=None, organization_attributes=None, result=None) -> dict:
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
                if attribute not in _existing_attributes.keys() or organization_attributes[attribute] != _existing_attributes[attribute]:
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


def tfe_org_workspace(hostname=None, headers=None, organization=None, workspace=None, workspace_attributes=None, result=None) -> dict:
    _tfe_ws_ep = f"https://{hostname}/api/v2/organizations/{organization}/workspaces/{workspace}"
    _tfe_existing_ws_response = requests.get(_tfe_ws_ep, timeout=30, headers=headers)
    if _tfe_existing_ws_response.status_code == 200:
        _tfe_ws_details = _tfe_existing_ws_response.json()
    elif _tfe_existing_ws_response.status_code == 404:
        _ws_create_data = {
            "data": {
                "type": "workspaces",
                "attributes": {}
            }
        }
        if workspace_attributes and len(workspace_attributes) > 0:
            _ws_create_data["data"]["attributes"] = workspace_attributes
        _ws_create_data["data"]["attributes"]["name"] = workspace
        _tfe_ws_create_response = requests.post(f"https://{hostname}/api/v2/organizations/{organization}/workspaces",
                                                timeout=30,
                                                headers=headers,
                                                json=_ws_create_data)
        if _tfe_ws_create_response.status_code == 201:
            result["changed"] = True
            result["workspace_created"] = True
            _tfe_newly_created_ws_details_response = requests.get(_tfe_ws_ep, timeout=30, headers=headers)
            if _tfe_newly_created_ws_details_response.status_code == 200:
                _tfe_ws_details = _tfe_newly_created_ws_details_response.json()
            else:
                result["error"] = {"status": _tfe_newly_created_ws_details_response.status_code, "msg": _tfe_newly_created_ws_details_response.json()}
                return result
        else:
            result["error"] = {"status": _tfe_ws_create_response.status_code, "msg": _tfe_ws_create_response.json()}
            return result
    else:
        result["error"] = {"status": _tfe_existing_ws_response.status_code, "msg": _tfe_existing_ws_response.json()}
        return result

    if not result["workspace_created"]:
        if workspace_attributes and len(workspace_attributes) > 0:
            _existing_attributes = _tfe_ws_details["data"]["attributes"]
            for attribute in workspace_attributes.keys():
                if attribute not in _existing_attributes.keys() or workspace_attributes[attribute] != _existing_attributes[attribute]:
                    _ws_update_data = {
                        "data": {
                            "type": "workspaces",
                            "attributes": workspace_attributes
                        }
                    }
                    _ws_update_response = requests.patch(_tfe_ws_ep, timeout=30, headers=headers, json=_ws_update_data)
                    if _ws_update_response.status_code == 200:
                        result["changed"] = True
                        result["workspace_updated"] = True
                        _tfe_ws_updated_details_response = requests.get(_tfe_ws_ep, timeout=30, headers=headers)
                        if _tfe_ws_updated_details_response.status_code == 200:
                            _tfe_ws_details = _tfe_ws_updated_details_response.json()
                        else:
                            result["error"] = {"status": _tfe_ws_updated_details_response.status_code, "msg": _tfe_ws_updated_details_response.json()}
                            return result
                        break

                    result["error"] = {"status": _ws_update_response.status_code, "msg": _ws_update_response.json()}
                    return result
    result["workspace"] = _tfe_ws_details
    return result


def crud(hostname=None, token=None, organization=None, organization_attributes=None, workspace=None, workspace_attributes=None) -> dict:
    result = {"changed": False,
              "organization_updated": False,
              "organization_created": False,
              "workspace_created": False,
              "workspace_updated": False}
    headers = {
        "Accept": "application/vnd.github+json",
        "content-type": "application/vnd.api+json",
        "Authorization": f"Bearer {token}"
    }
    if not hostname:
        result["error"] = "Hostname Can not be null"
        return result
    if not organization:
        result["error"] = "organization Can not be null"
        return result
    if not workspace:
        result["error"] = "workspace Can not be null"
        return result
    result = tfe_org(headers=headers,
                     organization=organization,
                     organization_attributes=organization_attributes,
                     hostname=hostname,
                     result=result,)
    if "error" in result.keys():
        return result
    result = tfe_org_workspace(headers=headers,
                               organization=organization,
                               hostname=hostname,
                               result=result,
                               workspace=workspace,
                               workspace_attributes=workspace_attributes,
                               )
    return result

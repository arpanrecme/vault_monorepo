#!/usr/bin/env python3
from __future__ import absolute_import, division, print_function

import base64

from ansible.errors import AnsibleError
from ansible.plugins.lookup import LookupBase
from ansible.utils.display import Display

__metaclass__ = type

DOCUMENTATION = """
  name: vault_root_token
  author: Arpan Mandal <arpan.rec@gmail.com>
  version_added: "0.9"  # for collections, use the collection version, not the Ansible version
  short_description: Get Vault root token from OTP and ERT
  description:
      - Regenerate vault root token, with base64 decode the encoded_root_token XOR with bytes of OTP
  options:
    encoded_root_token:
      description: Base64 encoded root token
      required: True
      type: string
    otp:
      description: OTP
      required: True
      type: string
  notes:
    - Nothing
"""

display = Display()


class LookupModule(LookupBase):
    def run(self, terms, variables=None, **kwargs):
        self.set_options(var_options=variables, direct=kwargs)
        display.debug("Recreating Vault root token")
        __encoded_root_token = self.get_option("encoded_root_token")
        display.vvvv(f"Encoded root token {__encoded_root_token}")
        __otp = self.get_option("otp")
        display.vvvv(f"OTP {__otp}")

        try:
            _root_token = base64.b64decode(
                bytearray(__encoded_root_token, "ascii") + b"=="
            )
            _otp_bytes = bytearray(__otp, "ascii")
            _final_root_token_bytes = bytearray()
            for i, j in zip(_root_token, _otp_bytes):
                _final_root_token_bytes.append(i ^ j)
        except BaseException as ex:
            raise AnsibleError(f"could not locate file in lookup: {ex}") from ex
        return [str(_final_root_token_bytes.decode("utf-8"))]

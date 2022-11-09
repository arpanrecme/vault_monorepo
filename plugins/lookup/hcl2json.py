#!/usr/bin/env python3
from __future__ import (absolute_import, division, print_function)
from ansible.plugins.lookup import LookupBase
from ansible.errors import AnsibleError
__metaclass__ = type

DOCUMENTATION = """
  name: hcl2json
  author: Arpan Mandal <arpan.rec@gmail.com>
  version_added: "1.0.0"  # for collections, use the collection version, not the Ansible version
  short_description: Convert HCL to JSON
  description:
      - Convert hashicorp configuration language to JSON
  options:
    path:
      description: path from hcl file
      required: false
      type: string
    content:
      description: hcl content
      required: false
      type: string
"""


class LookupModule(LookupBase):

    def run(self, terms, variables=None, **kwargs):
        self.set_options(var_options=variables, direct=kwargs)
        __hcl_path = self.get_option('path')
        __hcl_content = self.get_option('content')
        try:
            import hcl
            if __hcl_path and __hcl_content:
                raise AnsibleError("path and content is mutually exclusive")
            if __hcl_path:
                with open(__hcl_path, 'r', encoding="utf-8") as fp:
                    obj = hcl.load(fp)
            elif __hcl_content:
                obj = hcl.loads(__hcl_content)
            else:
                raise AnsibleError("Either path or content is required")
        except BaseException as ex:
            raise AnsibleError(f"Error in hcl: {ex}") from ex
        return [obj]

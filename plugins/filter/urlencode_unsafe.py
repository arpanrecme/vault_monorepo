#!/usr/bin/env python3

import urllib.parse


def urlencode_unsafe(string):
    return urllib.parse.quote(string.encode("utf-8"),  safe='').strip()


class FilterModule(object):

    def filters(self):
        return {
            'urlencode_unsafe': urlencode_unsafe
        }

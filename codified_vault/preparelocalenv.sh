#!/usr/bin/env bash

__BASEDIR=$(dirname "$0")
__TMPDIR="${__BASEDIR}"/../.tmp
__PREREQUISITEDIR="${__TMPDIR}"/prerequisite

TF_VAR_VAULT_MONO_JSON_VAULT_JWT_AUTH_BACKEND_OIDC_GSUITE_ADMIN=$(cat "${__PREREQUISITEDIR}"/secrets.vault_gsuite_oidc_conf.json)
export TF_VAR_VAULT_MONO_JSON_VAULT_JWT_AUTH_BACKEND_OIDC_GSUITE_ADMIN

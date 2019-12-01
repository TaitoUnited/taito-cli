#!/bin/bash -e

function semantic-release::get_token() {
  local token=
  local secret="${secret_value_version_control_buildbot_token:-$secret_value_github_buildbot_token}"

  if [[ "${secret}" == "secret_file:"* ]]; then
    token="$(cat ${secret#secret_file:})"
  else
    token="${secret}"
  fi

  # Azure DevOps workaround: test that the value is not an unsubstituted
  # variable name
  if [[ ! "${token}" ]] && [[ "${VC_TOKEN}" != *"VC_TOKEN"* ]]; then
    token="${VC_TOKEN}"
  fi

  echo "${token}"
}

function semantic-release::export_tokens() {
  local name=

  case "${taito_vc_provider:?}" in
  bitbucket)
    name='BB_TOKEN'
    ;;
  github)
    name='GH_TOKEN'
    ;;
  gitlab)
    name='GL_TOKEN'
    ;;
  esac

  export ${name}="$(semantic-release::get_token)"
  export NPM_TOKEN='none'
}

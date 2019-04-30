#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_env:?}"
: "${taito_zone:?}"
: "${taito_vc_repository:?}"
: "${taito_project:?}"

name=${1}

if "${taito_cli_path}/util/confirm-execution.sh" "bitbucket-ci" "${name}" \
  "Enable build pipelines for ${taito_project}"
then
  echo "Press enter to open build pipeline management"
  read -r
  "${taito_cli_path}/util/browser.sh" \
    "https://bitbucket.org/${taito_vc_repository_url:?}/addon/pipelines/home" && \
  echo "Press enter when ready" && \
  read -r
fi && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

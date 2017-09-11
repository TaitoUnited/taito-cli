#!/bin/bash

: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${taito_env:?}"

if [[ "${taito_env}" == "local" ]]; then
  echo
  echo "### postgres - ci-test-api: Deploying changes to database ${taito_env} ###"

  echo "TODO why connection fails?"
  # "${taito_plugin_path}/util/deploy-changes.sh"
fi && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

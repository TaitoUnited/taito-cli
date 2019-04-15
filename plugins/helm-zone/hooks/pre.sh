#!/bin/bash -e
: "${taito_cli_path:?}"
: "${taito_command:?}"

if [[ ${taito_command} == "zone-"* ]]; then
  # Run tillerless Helm
  (${taito_setv:?}; helm tiller start-ci > /dev/null)
  export HELM_HOST=127.0.0.1:44134
fi

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

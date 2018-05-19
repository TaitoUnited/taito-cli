#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"

# shellcheck disable=SC1090
. "${taito_plugin_path}/util/determine-pod.sh"

echo container: ${pod:?}

"${taito_cli_path}/util/execute-on-host.sh" \
  "docker ps; docker commit ${pod:?} ${pod:?}-savetus; echo ------"
"${taito_cli_path}/util/execute-on-host-fg.sh" \
  "docker image tag ${pod:?}-savetus ${pod:?}"

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

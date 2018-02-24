#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${taito_project:?}"

# shellcheck disable=SC1090
. "${taito_plugin_path}/util/determine-pod.sh" "${@}" && \

"${taito_cli_path}/util/execute-on-host-fg.sh" \
  "docker logs -f --tail 400 ${pod:?}" && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

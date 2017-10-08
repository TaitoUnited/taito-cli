#!/bin/bash

: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${taito_project:?}"

pod="${1:?Pod name not given}"

if [[ ${pod} != *"-"* ]]; then
  pod="${taito_project}-${pod}"
fi

echo
echo "### docker - o-shell: Opening shell on ${pod} ###"

"${taito_plugin_path}/util/exec.sh" "${pod}" "${2:--}" "/bin/sh" && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

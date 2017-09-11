#!/bin/bash

: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"

pod="${1:?Pod name not given}"

echo
echo "### docker - o-login: Loggin in to ${pod} ###"

"${taito_plugin_path}/util/exec.sh" "${1}" "${2:--}" "/bin/bash" && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

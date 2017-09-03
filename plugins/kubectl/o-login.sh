#!/bin/bash

: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${taito_customer:?}"
: "${taito_env:?}"

pod="${1:?Pod name not given}"

echo
echo "### kubectl - o-login: Logging in to ${pod} ###"
echo

# Change namespace
"${taito_plugin_path}/util/use-context.sh" && \

"${taito_plugin_path}/util/exec.sh" "${pod}" "${2:--}" /bin/bash && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

#!/bin/bash

: "${taito_cli_path:?}"
: "${taito_customer:?}"
: "${taito_env:?}"

pod="${1:?Pod name not given}"

echo
echo "### kubectl - o-kill: Killing pod ${pod} ###"
echo

# Change namespace
"${taito_plugin_path}/util/use-context.sh" && \

kubectl delete pod "${pod}" && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

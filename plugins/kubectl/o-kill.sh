#!/bin/bash

: "${taito_cli_path:?}"
: "${taito_customer:?}"
: "${taito_env:?}"
: "${taito_project:?}"

pod="${1:?Pod name not given}"

echo
echo "### kubectl - o-kill: Killing pod ${pod} ###"

# Change namespace
"${taito_plugin_path}/util/use-context.sh" && \

if [[ ${pod} != *"-"* ]]; then
  pod=$(kubectl get pods | grep server | head -n1 | awk '{print $1;}')
fi

kubectl delete pod "${pod}" && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

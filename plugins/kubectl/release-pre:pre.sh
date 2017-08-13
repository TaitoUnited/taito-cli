#!/bin/bash

: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${taito_customer:?}"
: "${taito_env:?}"

echo
echo "### kubectl - release-pre:pre: Getting secrets from Kubernetes ###"
echo

# Change namespace
if ! "${taito_plugin_path}/util/use-context.sh"; then
  exit 1
fi

# shellcheck disable=SC1090
. "${taito_plugin_path}/util/get-secrets.sh"

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

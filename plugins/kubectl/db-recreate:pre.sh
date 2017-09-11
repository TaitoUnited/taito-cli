#!/bin/bash

: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${taito_customer:?}"
: "${taito_env:?}"

echo
echo "### kubectl - db-recreate:pre: Getting current db password from \
Kubernetes ###"

# Change namespace
"${taito_plugin_path}/util/use-context.sh" && \

# shellcheck disable=SC1090
. "${taito_plugin_path}/util/get-secrets.sh" && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

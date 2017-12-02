#!/bin/bash

: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"

echo "Creating secrets"

# shellcheck disable=SC1090
. "${taito_plugin_path}/util/create.sh" && \

# Call next command on command chain. Exported variables:
"${taito_cli_path}/util/call-next.sh" "${@}"

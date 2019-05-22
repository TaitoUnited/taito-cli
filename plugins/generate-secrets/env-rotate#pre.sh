#!/bin/bash
: "${taito_util_path:?}"
: "${taito_plugin_path:?}"

name_filter="${1}"

echo "Creating secrets"

# shellcheck disable=SC1090
. "${taito_plugin_path}/util/create.sh" && \

# Call next command on command chain. Exported variables:
"${taito_util_path}/call-next.sh" "${@}"

#!/bin/bash
: "${taito_util_path:?}"
: "${taito_plugin_path:?}"
: "${taito_command:?}"

if [[ $taito_command == "zone-"* ]]; then
  "${taito_plugin_path}/../aws/util/auth.sh"
fi

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"

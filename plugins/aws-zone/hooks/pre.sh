#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_util_path:?}"
: "${taito_plugin_path:?}"
: "${taito_command:?}"

if [[ $taito_command == "zone-"* ]]; then
  echo
  echo "### aws/zone-pre"
  "${taito_cli_path}/plugins/aws/util/auth.sh"
fi

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"

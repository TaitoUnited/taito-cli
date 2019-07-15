#!/bin/bash
: "${taito_util_path:?}"
: "${taito_util_path:?}"
: "${taito_plugin_path:?}"
: "${taito_command:?}"

if [[ $taito_command == "zone-"* ]]; then
  echo
  echo -e "${taito_command_context_prefix:-}${H1s}aws-zone${H1e}"
  "${taito_cli_path}/plugins/aws/util/auth.sh"
fi

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"

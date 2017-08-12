#!/bin/bash

: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"

export template="${1}"
export template_name="${template}"

echo
echo "### template - template-create: Creating new project from template ${template} ###"
echo

if ! "${taito_plugin_path}/util/init.sh" "create"; then
  exit 1
fi

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

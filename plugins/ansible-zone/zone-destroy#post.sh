#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_env:?}"

name=${1}

if [[ ! $name ]] || [[ $name == "ansible" ]]; then
  echo "Delete servers manually. Press enter when done."
  read -r
fi

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

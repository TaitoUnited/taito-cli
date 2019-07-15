#!/bin/bash
: "${taito_util_path:?}"
: "${taito_env:?}"

name=${1}

if [[ ! $name ]] || [[ $name == "ansible" ]]; then
  echo "Delete servers manually. Press enter when done."
  read -r
fi

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"

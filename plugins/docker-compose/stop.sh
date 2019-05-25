#!/bin/bash
: "${taito_util_path:?}"

options=" ${*} "
if [[ "${options}" == *" --down "* ]]; then
  echo "ERROR: 'taito stop --down' is deprecated. Run 'taito down' instead".
  exit 1
fi

compose_file=$("$taito_plugin_path/util/prepare-compose-file.sh" false)
"${taito_util_path}/execute-on-host-fg.sh" "
  docker-compose -f $compose_file stop
"

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"

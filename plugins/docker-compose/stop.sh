#!/bin/bash
: "${taito_util_path:?}"

options=" ${*} "

command="stop"
if [[ "${options}" == *" --down "* ]]; then
  command="down -v"
fi

"${taito_util_path}/execute-on-host-fg.sh" "docker-compose ${command}" && \

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"

#!/bin/bash
: "${taito_util_path:?}"

compose_file=$("$taito_plugin_path/util/prepare-compose-file.sh" false)
"${taito_util_path}/execute-on-host-fg.sh" "
  docker-compose -f $compose_file ps
"

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"

#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${taito_target:?}"

source="${1:?}"
dest="${2:?}"

docker_cmd="docker cp ${source} ${taito_target}:${dest}"
"${taito_cli_path}/util/execute-on-host-fg.sh" "${docker_cmd}"

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

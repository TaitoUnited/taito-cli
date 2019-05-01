#!/bin/bash -e
: "${taito_util_path:?}"
: "${taito_plugin_path:?}"

export taito_docker_new_params=true
"${taito_plugin_path}/util/build.sh" "${@}"
"${taito_plugin_path}/util/push.sh" "${@}"

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"

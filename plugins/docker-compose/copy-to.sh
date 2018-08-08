#!/bin/bash
: "${taito_util_path:?}"
: "${taito_plugin_path:?}"
: "${taito_target:?}"

source="${1:?}"
dest="${2:?}"

# shellcheck disable=SC1090
. "${taito_plugin_path}/util/determine-pod.sh" && \

docker_cmd="docker cp ${source} ${pod:?}:${dest}"
"${taito_util_path}/execute-on-host-fg.sh" "${docker_cmd}"

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"

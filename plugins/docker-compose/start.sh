#!/bin/bash
: "${taito_util_path:?}"
: "${taito_plugin_path:?}"

if [[ -n "${taito_target:-}" ]]; then
  # Restart only the container given as argument
  # shellcheck disable=SC1090
  . "${taito_plugin_path}/util/determine-pod.sh"
  compose_file=$("$taito_plugin_path/util/prepare-compose-file.sh" false)
  "${taito_util_path}/execute-on-host-fg.sh" "
    docker-compose -f $compose_file start ${pod:-}
  "
else
  "${taito_plugin_path}/util/start.sh" "${@}"
fi


# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"

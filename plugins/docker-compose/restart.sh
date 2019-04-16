#!/bin/bash
: "${taito_util_path:?}"
: "${taito_plugin_path:?}"

if [[ -n "${taito_target:-}" ]]; then
  # Restart only the container given as argument
  # shellcheck disable=SC1090
  . "${taito_plugin_path}/util/determine-pod.sh" && \
  "${taito_util_path}/execute-on-host-fg.sh" \
    "docker-compose restart ${pod:?}"
else
  # Restart all containers
  "${taito_util_path}/execute-on-host-fg.sh" \
    "${taito_plugin_path}/util/start.sh" "${@}" --restart
fi && \

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"

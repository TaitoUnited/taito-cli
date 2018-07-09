#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"

if [[ -n "${taito_target:-}" ]]; then
  # Restart only the container given as argument
  # shellcheck disable=SC1090
  . "${taito_plugin_path}/util/determine-pod.sh" && \
  "${taito_cli_path}/util/execute-on-host-fg.sh" \
    "docker-compose restart ${pod:?}"
else
  # Restart all containers
  "${taito_cli_path}/util/execute-on-host-fg.sh" \
    "docker-compose stop" && \
  "${taito_cli_path}/util/execute-on-host-fg.sh" \
    "${taito_plugin_path}/util/start.sh" "${@}"
fi && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

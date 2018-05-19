#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${taito_project:?}"

command="${*}"

# shellcheck disable=SC1090
. "${taito_plugin_path}/util/determine-pod.sh" && \

compose_cmd="docker exec -it ${pod} ${command}" && \
if [[ -n "${docker_run:-}" ]]; then
  # Using run mode instead of up
  # TODO take --no-deps as param
  compose_cmd="docker-compose run --no-deps --entrypoint '${command}' ${pod}"
fi && \

"${taito_cli_path}/util/execute-on-host-fg.sh" "${compose_cmd}"

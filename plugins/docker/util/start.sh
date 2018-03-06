#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${taito_command:?}"

switches=" ${*} "

setenv=""
if [[ "${switches}" == *"--prod"* ]]; then
  setenv="dockerfile=Dockerfile.build "
fi

compose_cmd="up"
if [[ -n "${1}" ]] && [[ "${1}" != "--"* ]]; then
  docker_run="${1}"
fi
if [[ -n "${docker_run:-}" ]]; then
  # shellcheck disable=SC1090
  . "${taito_plugin_path}/util/determine-pod.sh" "${docker_run}" && \
  compose_cmd="run ${pod:?}"
fi

if [[ "${switches}" == *"--clean"* ]]; then
  "${taito_cli_path}/util/execute-on-host-fg.sh" \
    "${setenv}docker-compose ${compose_cmd} --force-recreate --build"
else
  "${taito_cli_path}/util/execute-on-host-fg.sh" \
    "${setenv}docker-compose ${compose_cmd}"
fi

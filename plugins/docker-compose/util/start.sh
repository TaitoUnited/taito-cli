#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${taito_command:?}"

switches=" ${*} "

setenv="dockerfile=Dockerfile "
if [[ "${switches}" == *"--prod"* ]]; then
  setenv="dockerfile=Dockerfile.build "
fi

compose_cmd="up"
if [[ -n "${taito_target:-}" ]]; then
  # shellcheck disable=SC1090
  . "${taito_plugin_path}/util/determine-pod.sh" && \
  compose_cmd="run ${pod:?}"
fi

flags=""
if [[ "${switches}" == *"--clean"* ]]; then
  flags="${flags} --force-recreate --build --remove-orphans \
    --renew-anon-volumes"
fi
if [[ "${switches}" == *"-b"* ]]; then
  flags="${flags} --detach"
fi

"${taito_cli_path}/util/execute-on-host-fg.sh" "\
  if [ -f ./taito-run-env.sh ]; then . ./taito-run-env.sh; fi && \
  ${setenv}docker-compose ${compose_cmd} ${flags} \
"

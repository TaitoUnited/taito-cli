#!/bin/bash
: "${taito_util_path:?}"
: "${taito_plugin_path:?}"
: "${taito_command:?}"
: "${taito_project:?}"

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

conditional_commands=
if [[ "${switches}" == *"--restart"* ]]; then
  # Run 'docker-compose stop' before start
  conditional_commands="
    ${conditional_commands}
    docker-compose stop
  "
fi
if [[ "${switches}" == *"--init"* ]] && [[ " ${taito_targets:-} " == *" database "* ]]; then
  # Run 'taito init' automatically after database container has started
  init_flags=
  if [[ "${switches}" == *"--clean"* ]]; then
    init_flags="--clean"
  fi

  conditional_commands="
    ${conditional_commands}
    init() {
      count=0
      while [[ \$count < 2000 ]] && \
            [[ ! \$(docker ps -q --filter 'status=running' --filter 'name=${taito_project}-database') ]]
      do
        sleep 2
        count=\$((\${count}+1))
      done
      sleep 15
      taito -q init ${init_flags} | cat
    }
    init &
  "
fi

"${taito_util_path}/execute-on-host-fg.sh" "
  if [ -f ./taito-run-env.sh ]; then . ./taito-run-env.sh; fi
  ${conditional_commands}
  ${setenv}docker-compose ${compose_cmd} ${flags}
"

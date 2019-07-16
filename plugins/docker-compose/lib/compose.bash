#!/bin/bash

function docker-compose::exec () {
  local commands
  commands=$(printf '"%s" ' "${@}")
  docker-compose::expose_pod_and_container

  if [[ -n "${docker_run:-}" ]]; then
    # Using run mode instead of up
    # TODO take --no-deps as param
    compose_file=$(docker-compose::prepare_docker_compose_yaml)
    taito::execute_on_host_fg \
      "docker-compose -f $compose_file run --no-deps --entrypoint ${commands} ${pod}"
  else
    taito::execute_on_host_fg "docker exec -it ${pod} ${commands}"
  fi
}

function docker-compose::expose_pod_and_container () {
  pod="${taito_target:?}"
  if [[ ${pod} != "${taito_project}-"* ]]; then
    pod="${taito_project}-${pod}"
  fi
}

function docker-compose::restart_all () {
  if [[ ${docker_compose_skip_restart:-} != "true" ]]; then
    echo
    echo "You may need to restart at least some of the containers to deploy the"
    echo "new secrets. For example:"
    echo
    echo "$ taito restart:server"
    echo "$ taito restart"
    echo
  fi
}

function docker-compose::start () {
  local options=" ${*} "

  local compose_file
  compose_file=$(docker-compose::prepare_docker_compose_yaml false)

  local setenv="dockerfile=Dockerfile "
  if [[ ${options} == *" --prod "* ]]; then
    setenv="dockerfile=Dockerfile.build "
  fi

  local compose_cmd="up"
  if [[ -n "${taito_target:-}" ]]; then
    docker-compose::expose_pod_and_container
    compose_cmd="run ${pod:?}"
  fi

  local flags=""
  if [[ ${options} == *" --clean "* ]]; then
    flags="${flags} --force-recreate --build --remove-orphans \
      --renew-anon-volumes"
  fi
  if [[ ${options} == *"-b"* ]] || [[ ${taito_target_env} != "local" ]]; then
    flags="${flags} --detach"
  fi

  local conditional_commands=
  if [[ ${options} == *" --clean "* ]]; then
    # Use longer http timeout
    conditional_commands="
      ${conditional_commands}
      export COMPOSE_HTTP_TIMEOUT=180
    "
  fi
  if [[ ${options} == *" --restart "* ]]; then
    # Run 'docker-compose stop' before start
    conditional_commands="
      ${conditional_commands}
      docker-compose -f $compose_file stop
    "
  fi
  if [[ ${options} == *" --init "* ]] && [[ " ${taito_targets:-} " == *" database "* ]]; then
    # Run 'taito init' automatically after database container has started
    local init_flags=
    # if [[ ${options} == *" --clean "* ]]; then
    #   init_flags="--clean"
    # fi

    # TODO: remove hardcoded database target: ${taito_project}-database
    # TODO: how to avoid hardcoded 'sleep 40'? DB container does not provide health checks.
    conditional_commands="
      ${conditional_commands}
      init() {
        count=0
        sleep 5
        while [ \$count -lt 3000 ] && \
              [ -z \"\$(docker ps -q --filter 'status=running' --filter 'name=${taito_project}-database')\" ]
        do
          sleep 2
          count=\$((\${count}+1))
        done
        sleep 10
        export taito_command_context='init'
        taito -q ${taito_options:-} init ${init_flags} | cat
      }
      init &
    "
  fi

  # TODO: remove taito-run-env (backwards compatibility -> only used in old projects)
  taito::execute_on_host_fg "
    if [ -f ./taito-run-env ]; then . ./taito-run-env; fi
    ${conditional_commands}
    ${setenv}docker-compose -f $compose_file ${compose_cmd} ${flags}
  "
}

# Prepares docker-compose.yaml and docker-nginx.conf by replacing
# local services. Prints filename of the new docker-compose.yaml
# that contains the modifications.
function docker-compose::prepare_docker_compose_yaml () {
  local create_config=$1

  if [[ ! ${docker_compose_local_services:-} ]]; then
    echo docker-compose.yaml
  else
    echo docker-compose.yaml.tmp
    if [[ $create_config != "false" ]] || [[ ! -f docker-compose.yaml.tmp ]]; then
      cp docker-nginx.conf docker-nginx.conf.tmp > /dev/null
      cp docker-compose.yaml docker-compose.yaml.tmp > /dev/null
      sed -i "s/docker-nginx.conf:/docker-nginx.conf.tmp:/" docker-compose.yaml.tmp\
        > /dev/null

      for service in $docker_compose_local_services; do
        name="${service%:*}"
        port="${service##*:}"
        sed -i "/^  $name:\$/,/^$/d" docker-compose.yaml.tmp > /dev/null
        sed -i "s/$name:.*;/host.docker.internal:$port;/" docker-nginx.conf.tmp \
          > /dev/null
      done
    fi
  fi
}

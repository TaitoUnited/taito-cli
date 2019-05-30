#!/bin/bash

# TODO: duplicate code with env-apply

switches=" ${*} "

if [[ "${taito_env}" != "local" ]] || [[ "${switches}" != *" --clean "* ]]; then
  echo "Not cleaning database containers"
else
  echo "Cleaning database container(s)"
  (
    all=$("$taito_util_path/get-targets-by-type.sh" database)
    databases=("${taito_target:-$all}")
    for database in ${databases[@]}
    do
      # TODO: duplicate code with clean.sh

      # shellcheck disable=SC1090
      . "${taito_plugin_path}/util/determine-pod.sh" "$database"

      # Docker-compose uses directory name as image prefix by default
      dir_name="${taito_host_project_path:-/taito-cli}"
      # Leave only directory name
      dir_name="${dir_name##*/}"

      compose_file=$("$taito_plugin_path/util/prepare-compose-file.sh" false)
      "${taito_util_path}/execute-on-host.sh" "
        docker-compose -f $compose_file stop ${pod:?}
        docker-compose -f $compose_file rm --force ${pod:?}
        docker-compose -f $compose_file up --force-recreate --build --no-start ${pod:?}
        docker-compose -f $compose_file start ${pod:?}
      "
    done
    if [[ ${all} ]]; then
      sleep 10
      echo
      echo "Waiting for databases to start..."
      sleep 30
      echo "Done waiting"
    fi
  )
fi && \

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"

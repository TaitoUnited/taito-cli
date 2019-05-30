#!/bin/bash

name=${1}

# TODO: duplicate code with env-apply

if [[ "${taito_env}" != "local" ]]; then
  echo "Skipping database create for remote environment"
else
  echo "Recreating database(s) by cleaning database container(s)"
  (
    all=$("$taito_util_path/get-targets-by-type.sh" database)
    databases=("${taito_target:-$all}")
    for database in ${databases[@]}
    do
      # TODO: duplicate code with clean.sh

      # shellcheck disable=SC1090
      taito_target=$database
      . "${taito_plugin_path}/util/determine-pod.sh"

      # Docker-compose uses directory name as image prefix by default
      dir_name="${taito_host_project_path:-/taito-cli}"
      # Leave only directory name
      dir_name="${dir_name##*/}"


      compose_file=$("$taito_plugin_path/util/prepare-compose-file.sh" false)
      "${taito_util_path}/execute-on-host-fg.sh" "
        docker-compose -f $compose_file stop ${pod:?}
        docker-compose -f $compose_file rm --force ${pod:?}
        docker-compose -f $compose_file up --force-recreate --build --no-start ${pod:?}
        docker-compose -f $compose_file start ${pod:?}
      "
    done
  )
fi && \

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"

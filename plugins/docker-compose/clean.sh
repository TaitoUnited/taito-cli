#!/bin/bash
: "${taito_util_path:?}"
: "${taito_plugin_path:?}"

if [[ ${taito_target:-} ]] && [[ "${taito_targets:-}" != *"${taito_target}"* ]]; then
  # Do nothing
  :
elif [[ ${taito_target:-} ]]; then
  # shellcheck disable=SC1090
  . "${taito_plugin_path}/util/determine-pod.sh"

  # Docker-compose uses directory name as image prefix by default
  dir_name="${taito_host_project_path:-/taito-cli}"
  # Leave only directory name
  dir_name="${dir_name##*/}"

  echo "NOTE: You must run 'taito stop' first or else clean fails"
  "${taito_util_path}/execute-on-host-fg.sh" \
    "docker rmi --force ${dir_name}_${pod:?}"
else
  # TODO [data | build] as arguments
  echo "Docker will remove images and volumes after taito-cli has exited"

  compose_file=$("$taito_plugin_path/util/prepare-compose-file.sh" false)
  "${taito_util_path}/execute-on-host-fg.sh" \
    "docker-compose -f $compose_file down --rmi 'local' --volumes --remove-orphans"
fi && \

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"

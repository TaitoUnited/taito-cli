#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"

if [[ ${taito_target:-} ]]; then
  # shellcheck disable=SC1090
  . "${taito_plugin_path}/util/determine-pod.sh"

  # Docker-compose uses directory name as project name by default
  project_name="${taito_host_project_path:?}"
  # Leave only directory name
  project_name="${project_name##*/}"
  # Remove special characters
  # project_name="${project_name//-/}"
  # project_name="${project_name//_/}"

  echo "NOTE: You must run 'taito stop' first or else clean fails"
  "${taito_cli_path}/util/execute-on-host-fg.sh" \
    "docker rmi --force ${project_name}_${pod:?}"
else
  # TODO [data | build] as arguments
  echo "Docker will remove images and volumes after taito-cli has exited"

  "${taito_cli_path}/util/execute-on-host-fg.sh" \
    "docker-compose down --rmi 'local' --volumes --remove-orphans"
fi && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

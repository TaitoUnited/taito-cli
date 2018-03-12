#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"

if [[ ${1} ]]; then
  # shellcheck disable=SC1090
  . "${taito_plugin_path}/util/determine-pod.sh" "${@}"

  # Docker-compose uses directory name as project name by default
  project_name="${taito_host_project_path:?}"
  # Leave only directory name
  project_name="${project_name##*/}"
  # Remove special characters
  project_name="${project_name//-/}"
  project_name="${project_name//_/}"

  echo "NOTE: docker-compose must not be running or else clean fails"
  "${taito_cli_path}/util/execute-on-host-fg.sh" \
    "docker rmi ${project_name}_${pod:?}"
else
  "${taito_plugin_path}/util/clean.sh" "${@}"
fi && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

#!/bin/bash
: "${taito_util_path:?}"
: "${taito_plugin_path:?}"

if [[ ${taito_target:-} ]] && [[ "${taito_targets:-}" != *"${taito_target}"* ]]; then
  # Do nothing
  :
elif [[ ${taito_target:-} ]]; then
  # shellcheck disable=SC1090
  . "${taito_plugin_path}/util/determine-pod.sh"

  echo "NOTE: You must run 'taito stop' first or else clean fails"
  "${taito_util_path}/execute-on-host-fg.sh" \
    "docker rmi --force ${pod:?}"
else
  # TODO [data | build] as arguments
  echo "Docker will remove images and volumes after taito-cli has exited"

  "${taito_util_path}/execute-on-host-fg.sh" \
    "docker-compose down --rmi 'local' --volumes --remove-orphans"
fi && \

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"

#!/bin/bash -e
: "${taito_util_path:?}"
: "${taito_plugin_path:?}"
: "${taito_namespace:?}"
: "${taito_env:?}"

switches=" ${*} "

if [[ ${taito_command} == "env-apply" ]]; then
  exec_after=""
  if [[ "${switches}" == *"--start"* ]]; then
    # taito start [--init]
    exec_after="taito -c start:${taito_env} --restart"
    if [[ "${switches}" == *"--init"* ]]; then
      exec_after="${exec_after} --init"
    fi
  elif [[ "${switches}" == *"--init"* ]]; then
    # taito init
    exec_after="taito -c init:${taito_env}"
  fi

  if [[ $exec_after ]] && [[ "${switches}" == *"--clean"* ]]; then
    # taito xxx --clean
    exec_after="${exec_after} --clean"
  fi

  if [[ $exec_after ]]; then
    "${taito_util_path}/execute-on-host-fg.sh" "
      echo
      echo ### docker-compose/post: Running '${exec_after}'
      echo
      ${exec_after}
    "
  else
    echo
    echo "### docker-compose/post: Showing information"
    echo
    "${taito_plugin_path}/util/restart-all.sh"
  fi
fi

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"

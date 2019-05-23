#!/bin/bash
# Calls the next command in the command chain and passes all arguments to it
: "${taito_util_path:?}"
: "${taito_debug:?}"

chain=(${taito_command_chain[@]})
next="${chain[0]}"

if [[ "${next}" != "" ]]; then
  name="${next//\/taito-cli\/plugins\//}"
  name=$(echo "${name}" | cut -f 1 -d '/')
  if [[ ${taito_quiet:-} != "true" ]] && ( \
       [[ "${taito_debug}" == "true" ]] || [[ "${next}" != *"/hooks/"* ]] \
     ); then
    echo
    echo -e "${H1s}${name}${H1e}"
  fi
  export taito_plugin_path
  taito_plugin_path=$(echo "${next/\hooks/}" | sed -e 's/\/[^\/]*$//g')
  taito_command_chain="${chain[@]:1}" "${next}" "${@}"
  exit $?
else
  exit 0
fi

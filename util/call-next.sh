#!/bin/bash
# Calls the next command in the command chain and passes all arguments to it
: "${taito_cli_path:?}"

chain=(${taito_command_chain[@]})
next="${chain[0]}"

if [[ "${next}" != "" ]]; then
  name="${next//\/taito-cli\/plugins\//}"
  name=$(echo "${name}" | cut -f 1 -d '.')
  echo
  echo "### ${name}"
  # TODO in verbose mode run command with bash -x
  . ${taito_cli_path}/util/set-taito-plugin-path.sh "${next}"
  taito_command_chain="${chain[@]:1}" "${next}" "${@}"
  exit $?
else
  exit 0
fi

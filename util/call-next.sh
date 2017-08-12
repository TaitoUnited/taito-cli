#!/bin/bash

# Calls the next command in the command chain and passes all arguments to it

chain=(${taito_command_chain[@]})
next="${chain[0]}"

if [[ "${next}" != "" ]]; then
  . ${taito_cli_path}/util/set-taito-plugin-path.sh "${next}"
  taito_command_chain="${chain[@]:1}" "${next}" "${@}"
  exit $?
else
  exit 0
fi

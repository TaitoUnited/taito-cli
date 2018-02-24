#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"

if [[ ${taito-command:-} == "env-delete" ]] || \
   [[ ${taito-command:-} == "env-alt-delete" ]]; then
  echo "Deleting environment ${taito_env}. Do you want to continue (Y/n)?"
  read -r confirm
  if ! [[ "${confirm}" =~ ^[Yy]$ ]]; then
    exit 130
  fi
fi && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

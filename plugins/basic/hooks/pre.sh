#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${taito_project_path:?}"
: "${taito_command:?}"

switches=" ${*} "

# auth command pre-handling
# if [[ "${taito_command:-}" == "auth" ]]; then
#   echo
#   echo "### basic/pre: Deleting old credentials (but not committing the change yet!)"
#   rm -rf ~/.config ~/.kube
# fi

if [[ ${taito_command} == "env-apply" ]] && \
   [[ "${switches}" == *"--clean"* ]]; then
  rm -rf "${taito_project_path}/tmp"
  rm -rf "${taito_project_path}/secrets"
fi

# env-destroy command pre-handling
if [[ ${taito_command:-} == "env-destroy" ]] || \
   [[ ${taito_command:-} == "env-alt-destroy" ]]; then
  echo
  echo "### basic/pre: Deleting ${taito_target_env:?} environment of ${taito_project:?}. Do you want to continue (Y/n)?"
  read -r confirm
  if ! [[ "${confirm}" =~ ^[Yy]*$ ]]; then
    exit 130
  fi
fi

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

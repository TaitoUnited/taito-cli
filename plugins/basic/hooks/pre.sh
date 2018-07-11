#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${taito_env:?}"
: "${taito_project:?}"

# --auth command pre-handling
if [[ "${taito_command:-}" == "__auth" ]]; then
  echo
  echo "### basic/pre: Deleting old credentials (but not committing the change yet!)"
  rm -rf ~/.config ~/.kube
fi

# env-destroy command pre-handling
if [[ ${taito_command:-} == "env-destroy" ]] || \
   [[ ${taito_command:-} == "env-alt-destroy" ]]; then
  echo "### basic/pre: Deleting environment ${taito_env} of ${taito_project}. Do you want to continue (Y/n)?"
  read -r confirm
  if ! [[ "${confirm}" =~ ^[Yy]*$ ]]; then
    exit 130
  fi
fi

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

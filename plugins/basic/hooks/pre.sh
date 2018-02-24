#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"

# --auth command pre-handling
if [[ "${taito_command:-}" == "__auth" ]]; then
  echo
  echo "### basic/pre: Deleting old credentials (but not committing the change yet!)"
  rm -rf ~/.config ~/.kube
fi

# env-delete command pre-handling
if [[ ${taito_command:-} == "env-delete" ]] || \
   [[ ${taito_command:-} == "env-alt-delete" ]]; then
  echo "### basic/pre: Deleting environment ${taito_env}. Do you want to continue (Y/n)?"
  read -r confirm
  if ! [[ "${confirm}" =~ ^[Yy]$ ]]; then
    exit 130
  fi
fi

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

#!/bin/bash
: "${taito_util_path:?}"
: "${taito_plugin_path:?}"
: "${taito_project_path:?}"
: "${taito_command:?}"

switches=" ${*} "

# auth command pre-handling
# if [[ "${taito_command:-}" == "auth" ]]; then
#   echo
#   echo -e "${H1s}basic${H1e}"
#   echo "Deleting old credentials (but not committing the change yet!)"
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
  echo -e "${H1s}basic${H1e}"
  echo "Deleting ${taito_target_env:?} environment of ${taito_project:?}"
  "${taito_util_path}/confirm.sh" "Do you really want to continue?" no
fi

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"

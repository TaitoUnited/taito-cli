#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${taito_command:?}"
: "${taito_env:?}"

# TODO: tighter filter
# NOTE: ci-release is deprecated
secret_filter=
if [[ ${taito_command} == "artifact-prepare" ]] || \
   [[ ${taito_command} == "artifact-release" ]] || \
   [[ ${taito_command} == "ci-release" ]]; then
  secret_filter="git"
elif [[ ${taito_commands_only_chain:-} == *"-db/"* ]] || \
   [[ ${taito_command} == "test" ]]; then
  secret_filter="db"
fi

if [[ ${secret_filter} ]]; then
  echo
  echo "### kubectl/pre: Getting secrets from Kubernetes"
  "${taito_cli_path}/plugins/kubectl/util/use-context.sh"
  # shellcheck disable=SC1090
  . "${taito_plugin_path}/util/get-secrets.sh" "true" ${secret_filter}
fi

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

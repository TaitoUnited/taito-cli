#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"

# NOTE: ci-release is deprecated
if [[ ${taito_commands_only_chain:-} == *"-db/"* ]] || \
   [[ ${taito_commands_only_chain:-} == *"artifact-release"* ]] || \
   [[ ${taito_commands_only_chain:-} == *"ci-release"* ]]; then
  # TODO fetch db secrets only? does artifact-release still require secrets?
  echo
  echo "### kubectl/pre: Getting secrets from Kubernetes"
  "${taito_cli_path}/plugins/kubectl/util/use-context.sh" && \
  # shellcheck disable=SC1090
  . "${taito_plugin_path}/util/get-secrets.sh"
fi

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

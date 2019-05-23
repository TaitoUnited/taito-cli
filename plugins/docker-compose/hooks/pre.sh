#!/bin/bash
: "${taito_util_path:?}"
: "${taito_plugin_path:?}"
: "${taito_env:?}"

# NOTE: ci-release is deprecated
if [[ ${taito_commands_only_chain:-} == *"-db/"* ]] || \
   [[ ${taito_commands_only_chain:-} == *"build-release"* ]] || \
   [[ ${taito_commands_only_chain:-} == *"artifact-release"* ]] || \
   [[ ${taito_commands_only_chain:-} == *"ci-release"* ]]; then
  # TODO fetch db secrets only? does artifact-release still require secrets?
  echo
  echo -e "${H1s}docker-compose${H1e}"
  echo "Getting secrets from ./secrets/${taito_env}"
  # shellcheck disable=SC1090
  . "${taito_plugin_path}/util/get-secrets.sh"
fi

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"

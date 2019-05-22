#!/bin/bash -e
: "${taito_util_path:?}"
: "${taito_plugin_path:?}"
: "${taito_namespace:?}"

options=" ${*} "
if [[ "${options}" == *" --all "* ]]; then
  "${taito_cli_path}/plugins/kubectl/util/use-context.sh"
  "${taito_plugin_path}/util/helm.sh" list --namespace "${taito_namespace}"
fi

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"

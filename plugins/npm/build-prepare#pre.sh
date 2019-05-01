#!/bin/bash
: "${taito_util_path:?}"
: "${taito_plugin_path:?}"
: "${taito_mode:?}"

if [[ $taito_mode != "ci" ]] || [[ ! -d ./node_modules ]]; then
  "${taito_plugin_path}/install.sh"
fi

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"

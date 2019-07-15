#!/bin/bash

if [[ "${taito_env:-}" == "local" ]]; then
  "${taito_plugin_path:?}/util/install.sh" "${@}"
else
  echo "Skipping install for non-local environment"
fi

# Call next command on command chain
"${taito_util_path:?}/call-next.sh" "${@}"

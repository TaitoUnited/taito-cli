#!/bin/bash

if [[ "${taito_env:-}" == "local" ]]; then
  "${taito_plugin_path:?}/util/install.sh" "${@}"
fi

# Call next command on command chain
"${taito_util_path:?}/call-next.sh" "${@}"

#!/bin/bash

if [[ "${taito_env:-}" == "local" ]]; then
  "${taito_plugin_path:?}/install.sh" "${@}"
fi

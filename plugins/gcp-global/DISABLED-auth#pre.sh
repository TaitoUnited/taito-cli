#!/bin/bash
: "${taito_util_path:?}"
: "${taito_enabled_plugins:?}"

if [[ " ${taito_enabled_plugins} " != *" gcp "* ]]; then
  echo "gcp plugin not enabled. authenticate using gcp util."
  taito_plugin_path="${taito_cli_path}/plugins/gcp" \
    "${taito_cli_path}/plugins/gcp/util/auth.sh" "${@}"
else
  echo "gcp plugin enabled. let gcp plugin authenticate."
fi && \

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"
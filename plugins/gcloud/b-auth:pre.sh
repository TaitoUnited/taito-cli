#!/bin/bash
: "${taito_cli_path:?}"

echo
echo "### gcloud - auth:pre: Authenticating ###"
echo

if ! "${taito_plugin_path}/util/auth.sh" "${@}"; then
  exit 1
fi

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

#!/bin/bash
: "${taito_cli_path:?}"

echo
echo "### gcloud - taito-auth:pre: Authenticating ###"
echo

"${taito_plugin_path}/util/auth.sh" "${@}" && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

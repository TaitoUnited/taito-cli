#!/bin/bash

: "${taito_cli_path:?}"

echo
echo "### gcloud - env-delete: Deleting environment ###"
echo "TODO not implemented"
echo "Delete these manually:"
echo "- DNS settings"
echo "- Uptime check"
echo "- Log alert rules"
echo
echo "Press enter when done"
read -r

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

#!/bin/bash

: "${taito_cli_path:?}"

echo
echo "### gcloud - delete: Deleting environment ###"
echo
echo "TODO not implemented"
echo
echo "Delete these manually:"
echo "- Build trigger"
echo "- DNS settings"
echo "- Custom SSL certificate"
echo "- Uptime check"
echo "- Log alert rules"
echo
echo "Press enter when done"
read -r

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

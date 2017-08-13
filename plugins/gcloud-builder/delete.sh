#!/bin/bash

: "${taito_cli_path:?}"

echo
echo "### gcloud-builder - delete: Deleting trigger ###"
echo
echo "TODO not implemented. Delete trigger manually."
echo
echo "Press enter when done"
read -r

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

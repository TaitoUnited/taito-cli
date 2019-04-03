#!/bin/bash
: "${taito_cli_path:?}"

echo
echo "NOTE: The current ssh plugin implementation uses keys that have been stored"
echo "in your ~/.ssh directory. The plugin doesn't currently support admin mode."
echo "Thus, your local ssh keys will also be used when executing as admin."
echo
echo "The implementation uses ~/.ssh/config.taito as default config if the file"
echo "exists."
echo
echo "Press enter to continue"
read -r

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

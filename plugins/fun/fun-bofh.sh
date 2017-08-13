#!/bin/bash

: "${taito_cli_path:?}"

echo
echo "### fun - fun-bofh: Bastard Operator from Hell! ###"
echo

telnet towel.blinkenlights.nl 666

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

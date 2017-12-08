#!/bin/bash

: "${taito_cli_path:?}"

telnet towel.blinkenlights.nl 23 && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

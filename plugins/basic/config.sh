#!/bin/bash
: "${taito_cli_path:?}"

# TODO: sort does not work well with multiline values (links, secrets, plugins)
env | sort

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

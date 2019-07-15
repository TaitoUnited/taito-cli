#!/bin/bash
: "${taito_util_path:?}"

# TODO: sort does not work well with multiline values (links, secrets, plugins)
env | sort

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"

#!/bin/bash
: "${taito_util_path:?}"
: "${taito_plugin_path:?}"

echo "Generating links to README.md"
"${taito_plugin_path}/util/generate.sh" && \

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"

#!/bin/bash

: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${taito_skip_override:?}"

echo
echo "### basic - --trouble: Showing troubleshooting files ###"

"${taito_plugin_path}/util/show_file.sh" trouble.txt && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

#!/bin/bash
: "${taito_util_path:?}"
: "${taito_plugin_path:?}"
: "${taito_skip_override:?}"

"${taito_plugin_path}/util/show_file.sh" trouble.txt taito-cli-first && \

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"
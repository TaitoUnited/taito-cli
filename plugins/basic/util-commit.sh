#!/bin/bash
: "${taito_util_path:?}"

"${taito_util_path}/docker-commit.sh" && \

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"

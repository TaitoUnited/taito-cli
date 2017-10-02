#!/bin/bash
: "${taito_cli_path:?}"

echo
echo "### basic - taito-auth:post: Asking host to commit new credentials to \
Docker container image ###"
echo "NOTE: Your credentials are saved to the taito container image."

"${taito_cli_path}/util/docker-commit.sh" && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

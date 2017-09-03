#!/bin/bash

: "${taito_cli_path:?}"

echo
echo "### gcloud-builder - ci-publish: Publishing artifacts ###"
echo

echo "TODO implement" && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

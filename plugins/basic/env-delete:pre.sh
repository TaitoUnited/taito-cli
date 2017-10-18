#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_env:?}"

echo
echo "### basic - env-delete:pre: Confirming env delete ###"

echo "Deleting environment ${taito_env}. Do you want to continue (Y/n)?"
read -r confirm
if ! [[ "${confirm}" =~ ^[Yy]$ ]]; then
  exit 130
fi

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

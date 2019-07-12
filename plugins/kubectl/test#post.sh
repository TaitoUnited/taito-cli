#!/bin/bash
: "${taito_util_path:?}"
: "${taito_project_path:?}"

proxy_secret_file="$taito_project_path/tmp/secrets/proxy_credentials.json"

if [[ -f $proxy_secret_file ]]; then
  echo "Deleting proxy secret from disk"
  rm -f "$proxy_secret_file"
fi

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"

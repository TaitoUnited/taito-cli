#!/bin/bash

: "${taito_util_path:?}"

if [[ "${1}" == "-c"* ]]; then
  collection="${2}"
  filter="${3}"
else
  collection="misc"
  filter="${1}"
fi

taito_secrets_url=gs://TODO/secrets/${collection}

gsutil ls "${taito_secrets_url}" | \
  sed -e "s|${taito_secrets_url}/||" | grep "${filter}" && \

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"

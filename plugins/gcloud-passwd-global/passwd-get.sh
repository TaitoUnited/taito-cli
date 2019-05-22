#!/bin/bash

: "${taito_util_path:?}"
: "${taito_plugin_path:?}"

if [[ "${1}" == "-c"* ]]; then
  collection="${2}"
  name="${3}"
else
  collection="misc"
  name="${1}"
fi

taito_secrets_key=TODO
taito_secrets_keyring=TODO
taito_secrets_region=TODO
taito_secrets_tzone=TODO
taito_secrets_url=gs://TODO/secrets/${collection}

if [[ "${name}" == "" ]]; then
  echo "Secret name:"
  read -r name
fi

echo "Fetching..."
# TODO do not use tmp files
mkdir -p "${HOME}/tmp"
cipher_path="${HOME}/tmp/cipher.tmp"

if ! gsutil cp "${taito_secrets_url}/${name}" "${cipher_path}"; then
  echo "ERROR: Copying encypted password from bucket failed."
  rm -f "${cipher_path}"
  exit 1
fi && \

echo "Decrypting..." && \
echo && \
echo "Password for ${name}:" && \
gcloud kms decrypt --keyring "${taito_secrets_keyring}" \
  --key "${taito_secrets_key}" \
  --location "${taito_secrets_region}" \
  --plaintext-file '-' \
  --ciphertext-file "${cipher_path}" \
  --project "${taito_secrets_tzone}"
# shellcheck disable=SC2181
if [[ $? -gt 0 ]]; then
  echo "ERROR: Decrypting password failed."
  rm -f "${cipher_path}"
  exit 1
fi && \
rm -f "${cipher_path}" && \

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"

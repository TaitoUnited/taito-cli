#!/bin/bash

: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${taito_command:?}"
: "${taito_zone:?}"

if [[ "${taito_is_admin:-}" == true ]] && \
   ( [[ "${taito_command}" == "env-"* ]] || \
     [[ "${taito_command}" == "db-"* ]] ); then

   echo "### taito/pre: Getting db password for admin"

   # TODO duplicate code with passwd-get

   collection=TODOdevops
   taito_secrets_key=TODO
   taito_secrets_keyring=TODO
   taito_secrets_region=TODO
   taito_secrets_tzone=TODO
   taito_secrets_url=gs://TODO/secrets/${collection}

   # TODO remove cluster name hardcoding
   name=TODO

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
   # TODO remove env name hardcoding
   export postgres_password && \
   postgres_password=$( \
     gcloud -q --project "${taito_zone}" kms decrypt --keyring "${taito_secrets_keyring}" \
       --key "${taito_secrets_key}" \
       --location "${taito_secrets_region}" \
       --plaintext-file '-' \
       --ciphertext-file "${cipher_path}" \
       --project "${taito_secrets_tzone}" \
   )

   # TODO pass as env variable instead -> pre handlers should be included
   # in the normal command chain!
   echo
   echo "postgres_password: ${postgres_password}"
   echo

   # shellcheck disable=SC2181
   if [[ $? -gt 0 ]]; then
     echo "ERROR: Decrypting password failed."
     rm -f "${cipher_path}"
     exit 1
   fi && \
   rm -f "${cipher_path}"
fi

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

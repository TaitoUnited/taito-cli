#!/bin/bash -e

secret_index=0
secret_names=(${taito_secret_names})
for secret_name in ${secret_names[@]}
do
  . "${taito_util_path}/secret-by-index.sh"
  if [[ "${secret_changed:-}" ]] && \
     [[ "${secret_value:-}" == "secret_file:"* ]]; then
    set -e
    file="${secret_value#secret_file:}"
    echo "Deleting file '${file}'"
    rm -f "${file}"
    echo "File '${file}' deleted successfully"
  fi
  secret_index=$((${secret_index}+1))
done

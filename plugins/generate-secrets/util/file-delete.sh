#!/bin/bash -e

secret_index=0
secret_names=(${taito_secret_names})
for secret_name in ${secret_names[@]}
do
  . "${taito_cli_path}/util/secret-by-index.sh"
  if ( \
      [[ "${secret_method:-}" == "file" ]] || \
      [[ "${secret_method:-}" == "csrkey" ]] || \
      [[ "${secret_method:-}" == "htpasswd"* ]] \
     ) && [[ "${secret_changed:-}" ]] && [[ "${secret_value:-}" ]]; then
    set -e
    echo "Deleting file '${secret_value:-}'"
    rm -f "${secret_value:-}"
    echo "File '${secret_value:-}' deleted successfully"
  fi
  secret_index=$((${secret_index}+1))
done

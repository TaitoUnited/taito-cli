#!/bin/bash

secret_index=0
secret_names=(${taito_secret_names})
for secret_name in ${secret_names[@]}
do
  . "${taito_cli_path}/util/secret-by-index.sh"
  if ( \
      [[ "${secret_method:-}" == "file" ]] || \
      [[ "${secret_method:-}" == "htpasswd"* ]] \
     ) && [[ "${secret_changed:-}" ]] && [[ "${secret_value:-}" ]]; then
    echo "Deleting file '${secret_value:-}'. Press enter to continue."
    read -r
    rm -f "${secret_value:-}"
  fi
  secret_index=$((${secret_index}+1))
done

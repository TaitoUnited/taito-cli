#!/bin/bash

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
    echo "Delete file '${secret_value:-}' (Y/n)?"
    read -r confirm
    if [[ "${confirm}" =~ ^[Yy]*$ ]]; then
      rm -f "${secret_value:-}"
    fi
  fi
  secret_index=$((${secret_index}+1))
done

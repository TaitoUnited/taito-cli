#!/bin/bash

secret_index=0
secret_names=(${taito_secret_names})
for secret_name in ${secret_names[@]}
do
  . "${taito_cli_path}/util/secret-by-index.sh"
  if [[ "${secret_method:-}" == "file" ]] && [[ "${secret_value:-}" ]]; then
    echo "Delete the file ${secret_value} from local disk (${secret_name})."
    echo "Also remember to empty your trashcan."
    echo "Press enter when the file has been deleted."
    read -r
  fi
  secret_index=$((${secret_index}+1))
done

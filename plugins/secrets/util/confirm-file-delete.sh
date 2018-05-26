#!/bin/bash

secret_names=(${taito_secret_names})
for secret_name in ${secret_names[@]}
do
  if [[ -z "${name_filter}" ]] || [[ ${secret_name} == *"${name_filter}"* ]]; then
    . "${taito_cli_path}/util/secret-by-index.sh"
    if [[ "${secret_method}" == "file" ]]; then
      echo "Delete the file ${secret_value} from local disk (${secret_name})."
      echo "Also remember to empty your trashcan."
      echo "Press enter when the file has been deleted."
      read -r
    fi
  fi
done

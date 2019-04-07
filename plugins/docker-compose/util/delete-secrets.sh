#!/bin/bash
: "${taito_project_path:?}"

# Delete secret values from ./secrets
secret_index=0
secret_names=(${taito_unformatted_secret_names})
for secret_name in "${secret_names[@]}"
do
  . "${taito_cli_path}/util/secret-by-index.sh"

  if [[ ${secret_method:?} != "read/"* ]]; then
    (
      ${taito_setv:?}
      rm -f "${taito_project_path}/secrets/${secret_name}.${secret_property:?}" || :
    )
  fi
  secret_index=$((${secret_index}+1))
done

echo

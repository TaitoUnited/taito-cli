#!/bin/bash
: "${taito_project_path:?}"
: "${taito_env:?}"

# Delete secret values from ./secrets
secret_index=0
secret_names=(${taito_secret_names})
for secret_name in "${secret_names[@]}"
do
  . "${taito_cli_path}/util/secret-by-index.sh"

  if [[ ${secret_method:?} != "read/"* ]]; then
    (
      ${taito_setv:?}
      rm -f "${taito_project_path}/secrets/${taito_env}/${secret_name}.${secret_property:?}" || :
    )
  fi
  secret_index=$((${secret_index}+1))
done

echo

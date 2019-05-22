#!/bin/bash
: "${taito_project_path:?}"
: "${taito_env:?}"

# Delete secret values from ./secrets
secret_index=0
secret_names=(${taito_secret_names})
for secret_name in "${secret_names[@]}"
do
  . "${taito_util_path}/secret-by-index.sh"

  # TODO remove once all project have been converted
  secret_property="SECRET"
  if [[ "${taito_version:-}" -ge "1" ]] || [[ "${secret_name:0:12}" != *"."* ]]; then
    # TODO: ugly hack that currently occurs in 4 places
    secret_property=$(echo ${secret_name} | sed 's/[^\.]*\.\(.*\)/\1/')
    secret_name=$(echo ${secret_name} | sed 's/\([^\.]*\).*/\1/')
  fi

  if [[ ${secret_method:?} != "read/"* ]]; then
    (
      ${taito_setv:?}
      rm -f "${taito_project_path}/secrets/${taito_env}/${secret_name}.${secret_property:?}" || :
    )
  fi
  secret_index=$((${secret_index}+1))
done

echo

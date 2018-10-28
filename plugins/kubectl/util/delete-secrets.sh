#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_env:?}"
: "${taito_project:?}"
: "${taito_env:?}"

secret_index=0
secret_names=(${taito_secret_names})
for secret_name in "${secret_names[@]}"
do
  . "${taito_cli_path}/util/secret-by-index.sh"

  # TODO remove once all projects have been converted
  secret_property="SECRET"
  if [[ "${taito_version:-}" -ge "1" ]] || [[ "${secret_name:0:12}" != *"."* ]]; then
    # TODO: ugly hack that currently occurs in 3 places
    secret_property=$(echo ${secret_name} | sed 's/[^\.]*\.\(.*\)/\1/')
    secret_name=$(echo ${secret_name} | sed 's/\([^\.]*\).*/\1/')
  fi

  if [[ ${secret_method:?} != "read/"* ]]; then
    (
      ${taito_setv:?}
      kubectl patch secret "${secret_name}" \
        --namespace="${secret_namespace}" \
        -p "{ \"data\": { \"${secret_property}\": null, \"${secret_property}.METHOD\": null } }"
    )
  fi
  secret_index=$((${secret_index}+1))
done

echo

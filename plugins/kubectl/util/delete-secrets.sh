#!/bin/bash
: "${taito_util_path:?}"
: "${taito_env:?}"
: "${taito_project:?}"
: "${taito_env:?}"

secret_index=0
secret_names=(${taito_secret_names})
for secret_name in "${secret_names[@]}"
do
  . "${taito_util_path}/secret-by-index.sh"

  # TODO remove once all projects have been converted
  secret_property="SECRET"
  formatted_secret_name=${secret_name//_/-}
  if [[ "${taito_version:-}" -ge "1" ]] || [[ "${formatted_secret_name:0:12}" != *"."* ]]; then
    # TODO: ugly hack that currently occurs in 3 places
    secret_property=$(echo ${formatted_secret_name} | sed 's/[^\.]*\.\(.*\)/\1/')
    formatted_secret_name=$(echo ${formatted_secret_name} | sed 's/\([^\.]*\).*/\1/')
  fi

  if [[ ${secret_method:?} != "read/"* ]]; then
    (
      # TODO: Do not just ignore fail, check if fail was ok (= not patched)
      ${taito_setv:?}
      kubectl patch secret "${formatted_secret_name}" \
        --namespace="${secret_namespace}" \
        -p "{ \"data\": { \"${secret_property}\": null, \"${secret_property}.METHOD\": null } }" || :
    )
  fi
  secret_index=$((${secret_index}+1))
done

echo

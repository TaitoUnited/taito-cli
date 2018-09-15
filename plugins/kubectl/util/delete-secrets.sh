#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_env:?}"
: "${taito_project:?}"
: "${taito_env:?}"

# TODO obsolete?
(
  ${taito_setv:?}
  kubectl delete secret "${taito_project}-${taito_env}-bucket" 2> /dev/null
)

# TODO obsolete?
(
  ${taito_setv:?}
  kubectl delete secret "${taito_project}-${taito_env}-basic-auth" 2> /dev/null
)

secret_index=0
secret_names=(${taito_secret_names})
for secret_name in "${secret_names[@]}"
do
  . "${taito_cli_path}/util/secret-by-index.sh"

  # TODO remove once all projects have been converted
  secret_property="SECRET"
  if [[ "${taito_version:-}" -ge "1" ]]; then
    secret_property="${secret_name##*.}"
    secret_name="${secret_name%.*}"
  fi

  if [[ ${secret_method:?} != "read/"* ]]; then
    (
      ${taito_setv:?}
      kubectl delete secret "${secret_name}" --namespace="${secret_namespace:?}"
    )
  fi
  secret_index=$((${secret_index}+1))
done

echo

#!/bin/bash
: "${taito_project_path:?}"

# Read secret values from ./secrets
secret_index=0
secret_names=(${taito_unformatted_secret_names})
for secret_name in "${secret_names[@]}"
do
  . "${taito_cli_path}/util/secret-by-index.sh"

  if [[ ${secret_method} != "copy/"* ]] && \
     [[ ${secret_method} != "file" ]] && \
     [[ ${secret_method} != "csrkey" ]]; then

    # TODO remove once all project have been converted
    secret_property="SECRET"
    if [[ "${taito_version:-}" -ge "1" ]] || [[ "${secret_name:0:12}" != *"."* ]]; then
      # TODO: ugly hack that currently occurs in 4 places
      secret_property=$(echo ${secret_name} | sed 's/[^\.]*\.\(.*\)/\1/')
      secret_name=$(echo ${secret_name} | sed 's/\([^\.]*\).*/\1/')
    fi

    echo "+ reading ${secret_name} from " \
      "${taito_project_path}/secrets/${secret_name}.${secret_property:?}" > \
      "${taito_vout:?}"
    secret_value=$(
      cat "${taito_project_path}/secrets/${secret_name}.${secret_property:?}" 2> /dev/null
    )

    exports="${exports}export ${secret_value_var}=\"${secret_value}\"; "
    exports="${exports}export ${secret_value_var2}=\"${secret_value}\"; "
  fi

  secret_index=$((${secret_index}+1))
done

eval "$exports"

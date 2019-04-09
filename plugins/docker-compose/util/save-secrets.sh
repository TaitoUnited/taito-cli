#!/bin/bash -e
: "${taito_project_path:?}"
: "${taito_env:?}"

# Save secret values to ./secrets
mkdir -p "${taito_project_path}/secrets/${taito_env}"
secret_index=0
secret_names=(${taito_secret_names})
for secret_name in "${secret_names[@]}"
do
  . "${taito_cli_path}/util/secret-by-index.sh"

  if [[ "${secret_changed:-}" ]] && \
     [[ "${secret_value:-}" ]] && \
     [[ "${secret_method:-}" != "read/"* ]]; then

    # TODO remove once all projects have been converted
    secret_property="SECRET"
    if [[ "${taito_version:-}" -ge "1" ]] || [[ "${secret_name:0:12}" != *"."* ]]; then
      # TODO: ugly hack that currently occurs in multiple places
      secret_property=$(echo ${secret_name} | sed 's/[^\.]*\.\(.*\)/\1/')
      secret_name=$(echo ${secret_name} | sed 's/\([^\.]*\).*/\1/')
    fi

    if [[ ${secret_value} == "secret_file:"* ]]; then
      yes | cp -f "${secret_value#secret_file:}" \
        "${taito_project_path}/secrets/${taito_env}/${secret_name}.${secret_property:?}"
    else
      printf "%s" "${secret_value}" > \
        "${taito_project_path}/secrets/${taito_env}/${secret_name}.${secret_property:?}"
    fi
  fi
  secret_index=$((${secret_index}+1))
done

if [[ ${docker_compose_skip_restart:-} != "true" ]]; then
  echo
  echo "You may need to restart the containers to deploy the new secrets:"
  echo
  echo "taito restart:TARGET"
  echo "taito restart"
  echo
fi
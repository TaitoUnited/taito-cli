#!/bin/bash

function kubectl::delete_secrets () {
  : "${taito_env:?}"
  : "${taito_project:?}"
  : "${taito_env:?}"

  local secret_name
  local secret_index=0
  local secret_names=(${taito_secret_names})
  for secret_name in "${secret_names[@]}"
  do
    taito::expose_secret_by_index ${secret_index}

    # TODO remove once all projects have been converted
    local secret_property="SECRET"
    local formatted_secret_name=${secret_name//_/-}
    if [[ "${taito_version:-}" -ge "1" ]] || \
       [[ "${formatted_secret_name:0:12}" != *"."* ]]
    then
      # TODO: ugly hack that currently occurs in 3 places
      secret_property=$(echo ${formatted_secret_name} | sed 's/[^\.]*\.\(.*\)/\1/')
      formatted_secret_name=$(echo ${formatted_secret_name} | sed 's/\([^\.]*\).*/\1/')
    fi

    if [[ ${secret_method:?} != "read/"* ]]; then
      (
        # TODO: Do not just ignore fail, check if fail was ok (= not patched)
        taito::executing_start
        kubectl patch secret "${formatted_secret_name}" \
          --namespace="${secret_namespace}" \
          -p "{ \"data\": { \"${secret_property}\": null, \"${secret_property}.METHOD\": null } }" || :
      )
    fi
    secret_index=$((${secret_index}+1))
  done

  echo
}

function kubectl::save_proxy_secret_to_disk () {
  : "${taito_project_path:?}"

  export taito_proxy_credentials_file=/project/tmp/secrets/proxy_credentials.json
  export taito_proxy_credentials_local_file="$taito_project_path/tmp/secrets/proxy_credentials.json"

  local taito_proxy_secret_name=
  local taito_proxy_secret_key=
  if [[ ${taito_ci_provider:-} == "gcp" ]]; then
    taito_proxy_secret_name=gcp-proxy-gserviceaccount
    taito_proxy_secret_key=key
  fi

  if [[ $taito_proxy_secret_name ]]; then
    echo "Getting proxy secret (devops/$taito_proxy_secret_name.$taito_proxy_secret_key) from Kubernetes"
    mkdir -p "$taito_project_path/tmp/secrets"
    kubectl get secret "$taito_proxy_secret_name" -o yaml --namespace devops 2> /dev/null | \
      grep "^  $taito_proxy_secret_key:" | \
      sed -e "s/^.*: //" | base64 --decode > "$taito_proxy_credentials_local_file"
    [[ -s "$taito_proxy_credentials_local_file" ]] || \
      echo "WARNING: Failed to get the proxy secret from Kubernetes"
  fi
}

function kubectl::export_secrets () {
  local save_to_disk=$1
  local filter=$2

  # Get secret values
  local secret_index=0
  local secret_names=(${taito_secret_names})
  for secret_name in "${secret_names[@]}"
  do
    taito::expose_secret_by_index ${secret_index}

    if [[ -n ${filter} ]] && \
       [[ "${secret_name}" != *"${filter}"* ]]; then
      secret_index=$((${secret_index}+1))
      continue
    fi

    # TODO remove once all project have been converted
    local secret_property="SECRET"
    local formatted_secret_name=${secret_name//_/-}
    if [[ "${taito_version:-}" -ge "1" ]] || [[ "${formatted_secret_name:0:12}" != *"."* ]]; then
      # TODO: ugly hack that currently occurs in 3 places
      secret_property=$(echo ${formatted_secret_name} | sed 's/[^\.]*\.\(.*\)/\1/')
      formatted_secret_name=$(echo ${formatted_secret_name} | sed 's/\([^\.]*\).*/\1/')
    fi

    echo "+ kubectl get secret ${formatted_secret_name}" \
      "--namespace=${secret_source_namespace} ..." > "${taito_vout}"

    local secret_value=""
    local base64=$(kubectl get secret "${formatted_secret_name}" -o yaml \
      --namespace="${secret_source_namespace}" 2> /dev/null | grep "^  ${secret_property}:" | \
      sed -e "s/^.*: //")

    if [[ ${base64} ]]; then
      # write secret value to file
      if [[ "${save_to_disk}" == "true" ]]; then
        mkdir -p "${taito_project_path}/tmp/secrets/${taito_env}"
        file="${taito_project_path}/tmp/secrets/${taito_env}/${secret_name}"
        echo "Saving secret to ${file}" > "${taito_vout}"
        echo "${base64}" | base64 --decode > "${file}"
        # TODO: save to a separate env var (secret_value should always be value)
        secret_value="secret_file:${file}"
      fi

      if [[ "${secret_method:?}" == "random" ]] || \
         [[ "${secret_method}" == "manual" ]] || (
           [[ "${secret_method}" == "htpasswd"* ]] && \
           [[ "${save_to_disk}" == "false" ]] \
         ); then
        # use secret as value instead of file path
        secret_value=$(echo "${base64}" | base64 --decode)
      fi

      set +x
      # shellcheck disable=SC2181
      if [[ $? -gt 0 ]]; then
        exit 1
      fi
      exports="${exports}export ${secret_value_var}=\"${secret_value}\"; "
      exports="${exports}export ${secret_value_var2}=\"${secret_value}\"; "
    fi

    secret_index=$((${secret_index}+1))
  done

  eval "$exports"
}

function kubectl::save_secrets () {
  : "${taito_env:?}"
  : "${taito_project:?}"
  : "${taito_namespace:?}"
  : "${kubernetes_skip_restart:-}"

  local secret_name
  local formatted_secret_name
  local secret_property
  local secret_value
  local secret_source
  local json
  local data_only

  # Validate secret values
  # TODO: why here? should be in generate secrets.
  local secret_index=0
  local secret_names=(${taito_secret_names})
  for secret_name in "${secret_names[@]}"
  do
    taito::expose_secret_by_index ${secret_index}
    if [[ "${secret_value:-}" ]] && [[ ${#secret_value} -lt 8 ]] && \
       [[ ${secret_method} != "copy/"* ]] && [[ ${secret_method} != "read/"* ]]; then
      echo "ERROR: secret ${secret_namespace}/${secret_name} too short or not set"
      exit 1
    fi
    secret_index=$((${secret_index}+1))
  done

  # Save secret values
  secret_index=0
  for secret_name in "${secret_names[@]}"
  do
    taito::expose_secret_by_index ${secret_index}

    if  [[ "${secret_changed:-}" ]] && ( \
          [[ "${secret_value:-}" ]] || [[ ${secret_method} == "copy/"* ]] \
        ); then

      # TODO remove once all projects have been converted
      secret_property="SECRET"
      formatted_secret_name=${secret_name//_/-}
      if [[ "${taito_version:-}" -ge "1" ]] || [[ "${formatted_secret_name:0:12}" != *"."* ]]; then
        # TODO: ugly hack that currently occurs in 3 places
        secret_property=$(echo ${formatted_secret_name} | sed 's/[^\.]*\.\(.*\)/\1/')
        formatted_secret_name=$(echo ${formatted_secret_name} | sed 's/\([^\.]*\).*/\1/')
      fi

      if [[ ${secret_name} == *"_"* ]]; then
        taito::print_note_start
        echo "NOTE: Secret name '${secret_name}' contains an underscore (_)."
        echo "Underscores are converted to hyphen (-) when secret is stored to Kubernetes."
        echo "It's best to avoid underscores in secret names."
        echo
        echo "SECRET NAME WAS CONVERTED TO: ${formatted_secret_name}"
        taito::print_note_end
      fi

      if [[ ${secret_method} == "copy/"* ]]; then
        secret_value=$(kubectl get secret "${formatted_secret_name}" -o yaml \
          --namespace="${secret_source_namespace}" | grep "^  ${secret_property}" | \
          sed -e "s/^.*: //" | base64 --decode)
      fi

      if [[ ${secret_method} != "read/"* ]]; then
        (
          taito::executing_start
          secret_source="literal"
          if [[ ${secret_value} == "secret_file:"* ]]; then
            secret_source="file"
            secret_value=${secret_value#secret_file:}
          fi

          # Secrets as json
          json=$(kubectl create secret generic "${formatted_secret_name}" \
            --namespace="${secret_namespace}" \
            --from-${secret_source}=${secret_property}="${secret_value}" \
            --from-literal=${secret_property}.METHOD="${secret_method}" \
            --dry-run -o json)

          if kubectl get secret "${formatted_secret_name}" \
               --namespace="${secret_namespace}" &> /dev/null; then
            # Patch an existing secret
            # TODO: Do not just ignore fail, check if fail was ok (= not patched)
            data_only=$(echo "${json}" | jq '.data')
            kubectl patch secret "${formatted_secret_name}" \
              --namespace="${secret_namespace}" \
              -p "{ \"data\": ${data_only} }" || :
          else
            # Create new secret
            kubectl::ensure_namespace "${secret_namespace}"
            echo "${json}" | kubectl apply -f -
          fi

        )
        # shellcheck disable=SC2181
        if [[ $? -gt 0 ]]; then
         exit 1
        fi
      fi
    fi
    secret_index=$((${secret_index}+1))
  done

  if [[ ${kubernetes_skip_restart:-} != "true" ]]; then
    echo
    if taito::confirm "Restart all pods in namespace ${taito_namespace}?"; then
      echo "Restarting pods"
      echo "TODO rolling update instead of delete?"
      (taito::executing_start; kubectl delete --all pods --namespace="${taito_namespace}")
    fi
  fi
}

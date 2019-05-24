#!/bin/bash
: "${taito_plugin_path:?}"
: "${taito_env:?}"
: "${taito_project:?}"
: "${taito_namespace:?}"
: "${kubernetes_skip_restart:-}"

script_dir=$(dirname "$0")

# Validate secret values
# TODO: why here? should be in generate secrets.
secret_index=0
secret_names=(${taito_secret_names})
for secret_name in "${secret_names[@]}"
do
  . "${taito_util_path}/secret-by-index.sh"
  if [[ "${secret_value:-}" ]] && [[ ${#secret_value} -lt 8 ]] && \
     [[ ${secret_method} != "copy/"* ]] && [[ ${secret_method} != "read/"* ]]; then
    echo "ERROR: secret ${secret_namespace}/${secret_name} too short or not set"
    exit 1
  fi
  secret_index=$((${secret_index}+1))
done && \

# Save secret values
secret_index=0
for secret_name in "${secret_names[@]}"
do
  . "${taito_util_path}/secret-by-index.sh"

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

    if [[ ${secret_method} == "copy/"* ]]; then
      secret_value=$(kubectl get secret "${formatted_secret_name}" -o yaml \
        --namespace="${secret_source_namespace}" | grep "^  ${secret_property}" | \
        sed -e "s/^.*: //" | base64 --decode)
    fi

    if [[ ${secret_method} != "read/"* ]]; then
      (
        ${taito_setv:?}
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
          data_only=$(echo "${json}" | jq '.data')
          kubectl patch secret "${formatted_secret_name}" \
            --namespace="${secret_namespace}" \
            -p "{ \"data\": ${data_only} }"
        else
          # Create new secret
          "${script_dir}/ensure-namespace.sh" "${secret_namespace}"
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
done && \

if [[ ${kubernetes_skip_restart:-} != "true" ]]; then
  echo && \
  echo "Restart all pods in namespace ${taito_namespace} (Y/n)?" && \
  read -r confirm && \
  if [[ "${confirm}" =~ ^[Yy]*$ ]]; then
    echo "Restarting pods" && \
    echo "TODO rolling update instead of delete?" && \
    (${taito_setv:?}; kubectl delete --all pods --namespace="${taito_namespace}")
  fi
fi

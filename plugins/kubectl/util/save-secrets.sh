#!/bin/bash
: "${taito_plugin_path:?}"
: "${taito_env:?}"
: "${taito_project:?}"
: "${taito_namespace:?}"
: "${kubectl_skip_restart:-}"

# Validate secret values
secret_index=0
secret_names=(${taito_secret_names})
for secret_name in "${secret_names[@]}"
do
  . "${taito_cli_path}/util/secret-by-index.sh"
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
  . "${taito_cli_path}/util/secret-by-index.sh"

  if  [[ "${secret_changed:-}" ]] && ( \
        [[ "${secret_value:-}" ]] || [[ ${secret_method} == "copy/"* ]] \
      ); then

    # TODO remove once all projects have been converted
    secret_property="SECRET"
    if [[ "${taito_secrets_version:-}" == "2" ]]; then
      secret_property="${secret_name##*.}"
      secret_name="${secret_name%.*}"
    fi

    if [[ ${secret_method} == "copy/"* ]]; then
      secret_value=$(kubectl get secret "${secret_name}" -o yaml \
        --namespace="${secret_source_namespace}" | grep "^  ${secret_property}" | \
        sed -e "s/^.*: //" | base64 --decode)
    fi

    if [[ ${secret_method} != "read/"* ]]; then
      (
        ${taito_setv:?}
        kubectl create namespace "${secret_namespace}" &> /dev/null
        kubectl delete secret "${secret_name}" \
          --namespace="${secret_namespace}" 2> /dev/null
        secret_source="literal"
        if [[ ${secret_method} == "file" ]] || \
           [[ ${secret_method} == "htpasswd" ]]; then
          secret_source="file"
        fi
        kubectl create secret generic "${secret_name}" \
          --namespace="${secret_namespace}" \
          --from-${secret_source}=${secret_property}="${secret_value}" \
          --from-literal=METHOD="${secret_method}"
      )
      # shellcheck disable=SC2181
      if [[ $? -gt 0 ]]; then
       exit 1
      fi
    fi
  fi
  secret_index=$((${secret_index}+1))
done && \

if [[ ${kubectl_skip_restart:-} != "true" ]]; then
  echo && \
  echo "Restart all pods in namespace ${taito_namespace} (Y/n)?" && \
  read -r confirm && \
  if [[ "${confirm}" =~ ^[Yy]*$ ]]; then
    echo "Restarting pods..." && \
    echo "TODO rolling update instead of delete?" && \
    (${taito_setv:?}; kubectl delete --all pods --namespace="${taito_namespace}")
  fi
fi

#!/bin/bash -e

function kubectl::db_proxy_start () {
  if [[ ${kubernetes_db_proxy_enabled:-} == "true" ]]; then
    if taito::is_target_of_type "container" "${taito_target:-database}"; then
      (
        export taito_target="${taito_target:-database}"
        kubectl::expose_pod_and_container false &> "${taito_vout:-}"
        echo "BIND ADDRESS: ${taito_db_proxy_bind_address:?}" > "${taito_vout:-}"
        taito::executing_start
        if [[ -z ${pod:-} ]]; then
          echo "WARNING: Database proxy was not started. Database container not found."
        else
          kubectl port-forward \
            "${pod:?}" \
            "${database_port:?}:${database_real_port:-5432}" \
            --address "${taito_db_proxy_bind_address}" \
            --namespace "${taito_namespace:?}" > /dev/null &
          sleep 1
          if [[ $1 != "true" ]]; then
            wait
          else
            sleep 3
          fi
        fi
      )
    elif [[ "${database_instance}" ]]; then
      proxy_namespace="db-proxy"
      proxy_instance="${database_instance:?}"

      # tcp-proxy still in use in old test zones (TODO: REMOVE)
      if [[ " gcloud-temp1 azure-test-256814 do-test-zone " == "${taito_zone:-}" ]]; then
        proxy_namespace="tcp-proxy"
        proxy_instance="tcp-proxy"
      fi

      local proxy_pod
      proxy_pod=$(yes | kubectl get pods --no-headers \
        --output=custom-columns=NAME:.metadata.name \
        --namespace "${proxy_namespace}" | grep "${proxy_instance}" | head -n 1
      )

      if [[ -z ${proxy_pod:-} ]]; then
        echo "WARNING: Database proxy was not started. Database pod not found."
      else
        (
          echo "BIND ADDRESS: ${taito_db_proxy_bind_address:?}" > "${taito_vout:-}"
          taito::executing_start
          kubectl port-forward \
            "${proxy_pod}" \
            "${database_port:?}:${database_real_port:-5432}" \
            --address "${taito_db_proxy_bind_address}" \
            --namespace "${proxy_namespace}" > /dev/null &
          sleep 1
          if [[ $1 != "true" ]]; then
            wait
          else
            sleep 3
          fi
        )
      fi
    else
      echo "Database details not known. Skipping database proxy."
    fi
  fi
}

function kubectl::db_proxy_stop () {
  if [[ ${kubernetes_db_proxy_enabled:-} == "true" ]]; then
    # TODO: kill only the kubectl port-forward execution
    (
      taito::executing_start
      pgrep kubectl | xargs kill &> "${taito_vout:-}" || \
        echo "Database proxy was not stopped as no database proxy was running."
    )
  fi
}

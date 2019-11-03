#!/bin/bash -e

function kubectl::db_proxy_start () {
  if [[ ${kubernetes_db_proxy_enabled:-} == "true" ]]; then
    local proxy_pod
    proxy_pod=$(kubectl get pods --no-headers \
      --output=custom-columns=NAME:.metadata.name \
      --namespace tcp-proxy | head -n 1
    )
    echo "BIND ADDRESS: ${taito_db_proxy_bind_address:?}" > "${taito_vout:-}"
    taito::executing_start
    kubectl port-forward \
      "${proxy_pod}" \
      "${database_port:?}:${database_real_port:-5432}" \
      --address "${taito_db_proxy_bind_address}" \
      --namespace tcp-proxy > /dev/null &
    sleep 1
    if [[ $1 != "true" ]]; then
      wait
    else
      sleep 3
    fi
  fi
}

function kubectl::db_proxy_stop () {
  if [[ ${kubernetes_db_proxy_enabled:-} == "true" ]]; then
    # TODO: kill only the kubectl port-forward execution
    (taito::executing_start; pgrep kubectl | xargs kill)
  fi
}

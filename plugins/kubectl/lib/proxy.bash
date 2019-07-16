#!/bin/bash -e

function kubectl::db_proxy_start () {
  local proxy_pod
  local bind_address="127.0.0.1"
  if [[ "${taito_docker:-}" == "true" ]]; then
    bind_address="0.0.0.0"
  fi

  if [[ ${kubernetes_db_proxy_enabled:-} == "true" ]]; then
    proxy_pod=$(kubectl get pods --no-headers \
      --output=custom-columns=NAME:.metadata.name \
      --namespace tcp-proxy | head -n 1
    )
    ${taito_setv:?}
    # TODO: SET "--address $bind_address" ONCE KUBECTL VERSION 1.13
    kubectl port-forward "${proxy_pod}" "${database_port:?}:${database_real_port:-5432}" \
      --namespace tcp-proxy > /dev/null &
    sleep 1
    if [[ $1 != "true" ]]; then
      wait
    fi
  fi
}

function kubectl::db_proxy_stop () {
  if [[ ${kubernetes_db_proxy_enabled:-} == "true" ]]; then
    # TODO: kill only the kubectl port-forward execution
    (${taito_setv:?}; pgrep kubectl | xargs kill)
  fi
}

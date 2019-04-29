#!/bin/bash
: "${taito_verbose:?}"
: "${taito_vout:?}"

bind_address="127.0.0.1"
if [[ "${taito_docker:-}" == "true" ]]; then
  bind_address="0.0.0.0"
fi

if [[ -n "${database_proxy_port:-}" ]]; then
  proxy_pod=$(kubectl get pods --no-headers \
    --output=custom-columns=NAME:.metadata.name \
    --namespace tcp-proxy | head -n 1
  )
  ${taito_setv:?}
  # TODO: SET "--address $bind_address" ONCE KUBECTL VERSION 1.13
  # TODO: remove hardcoded port
  kubectl port-forward "${proxy_pod}" \
    "${database_proxy_port:?}:5432" \
    --namespace tcp-proxy > /dev/null &
  sleep 1
  if [[ $1 != "true" ]]; then
    wait
  fi
fi

#!/bin/bash
: "${taito_namespace:?}"

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

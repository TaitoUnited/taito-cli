#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${taito_namespace:?}"
: "${taito_target_env:?}"

switch="${1}"
if [[ "${switch}" == "--all" ]]; then
  params=("${@:2}")
else
  params=("${@:1}")
fi

"${taito_plugin_path}/util/use-context.sh"

if [[ "${switch}" == "--all" ]]; then
  echo "--- Node details ---"
  (${taito_setv:?}; kubectl describe nodes)
  echo
  echo "--- Nodes ---"
  (${taito_setv:?}; kubectl top nodes)
  echo
  echo "--- Ingress ---"
  (${taito_setv:?}; kubectl get ingress "${params[@]}")
  echo
  echo "--- Services ---"
  (${taito_setv:?}; kubectl get services "${params[@]}")
  echo
  echo "--- Jobs ---"
  (${taito_setv:?}; kubectl get jobs "${params[@]}")
  echo
  echo "--- CronJobs ---"
  (${taito_setv:?}; kubectl get cronjobs "${params[@]}")
  echo
  echo "--- Pods ---"
  (${taito_setv:?}; kubectl get pods "${params[@]}" | grep -e "${taito_target_env}\\|RESTARTS")
elif [[ "${taito_version:-}" -ge "1" ]]; then
  echo
  echo "--- CronJobs ---"
  (${taito_setv:?}; kubectl get cronjobs "${params[@]}")
  echo
  echo "--- Pods ---"
  (${taito_setv:?}; kubectl get pods "${params[@]}" | grep -e "${taito_target_env}\\|RESTARTS")
else
  echo
  echo "--- CronJobs ---"
  (${taito_setv:?}; kubectl get cronjobs "${params[@]}")
  echo
  echo "--- Pods ---"
  (${taito_setv:?}; kubectl get pods "${params[@]}")
fi


# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

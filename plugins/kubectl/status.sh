#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${taito_namespace:?}"
: "${taito_target_env:?}"
: "${taito_setv:?}"

all=false
kubernetes_params=""
args=( "$@"  )
while [ $# -gt 0 ]
do
  case $1 in
    --all)
      all=true
      shift
      ;;
    --all-namespaces)
      kubernetes_params="--all-namespaces"
      shift
      ;;
  esac
done

"$taito_plugin_path/util/use-context.sh"

if [ $all = true ]; then
  echo "--- Node details ---"
  ($taito_setv; kubectl describe nodes)
  echo
  echo "--- Nodes ---"
  ($taito_setv; kubectl top nodes 2> /dev/null)
  echo
  echo "--- Ingress ---"
  ($taito_setv; kubectl get ingress $kubernetes_params)
  echo
  echo "--- Jobs ---"
  ($taito_setv; kubectl get jobs $kubernetes_params)
fi

echo
echo "--- Cron jobs ---"
($taito_setv; kubectl get cronjobs $kubernetes_params)

if [ "${taito_version:-}" -ge "1" ]; then
  echo
  echo "--- Pods ---"
  ($taito_setv; kubectl get pods $kubernetes_params | grep -e "${taito_target_env}\\|NAME")
  echo
  echo "--- Resource usage ---"
  ($taito_setv; kubectl top pod $kubernetes_params 2> /dev/null | grep -e "${taito_target_env}\\|NAME")
else
  echo
  echo "--- Pods ---"
  ($taito_setv; kubectl get pods $kubernetes_params)
  echo
  echo "--- Resource usage ---"
  ($taito_setv; kubectl top pod $kubernetes_params 2> /dev/null)
fi

echo
if [ $all = false ]; then
  echo "NOTE: See more info with '--all'"
fi
if [ ! $kubernetes_params ]; then
  echo "NOTE: See all namespaces with '--all-namespaces'"
fi

# Call next command on command chain
"$taito_cli_path/util/call-next.sh" "${args[@]}"

#!/bin/sh -e
: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${taito_namespace:?}"
: "${taito_target_env:?}"
: "${taito_setv:?}"

all=false
kubectl_params=""
while [ $# -gt 0 ]
do
  case $1 in
    --all)
      all=true
      shift
      ;;
    --all-namespaces)
      kubectl_params="--all-namespaces"
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
  ($taito_setv; kubectl top nodes)
  echo
  echo "--- Ingress ---"
  ($taito_setv; kubectl get ingress $kubectl_params)
  echo
  echo "--- Jobs ---"
  ($taito_setv; kubectl get jobs $kubectl_params)
fi

echo
echo "--- Cron jobs ---"
($taito_setv; kubectl get cronjobs $kubectl_params)

if [ "${taito_version:-}" -ge "1" ]; then
  echo
  echo "--- Pods ---"
  ($taito_setv; kubectl get pods $kubectl_params | grep -e "${taito_target_env}\\|NAME")
  echo
  echo "--- Resource usage ---"
  ($taito_setv; kubectl top pod $kubectl_params | grep -e "${taito_target_env}\\|NAME")
else
  echo
  echo "--- Pods ---"
  ($taito_setv; kubectl get pods $kubectl_params)
  echo
  echo "--- Resource usage ---"
  ($taito_setv; kubectl top pod $kubectl_params)
fi

echo
if [ $all = false ]; then
  echo "NOTE: See more info with '--all'"
fi
if [ ! $kubectl_params ]; then
  echo "NOTE: See all namespaces with '--all-namespaces'"
fi

# Call next command on command chain
"$taito_cli_path/util/call-next.sh" "$@"

#!/bin/bash
: "${taito_util_path:?}"
: "${taito_plugin_path:?}"

"${taito_plugin_path}/util/use-context.sh"

# Wait until all containers have been deployed
sleep 5
while [[ -n $(kubectl get pods | grep ContainerCreating) ]]
do
  echo "Waiting until all containers have been deployed"
  sleep 5
done
sleep 15

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"

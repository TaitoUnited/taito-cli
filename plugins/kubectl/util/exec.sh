#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${taito_namespace:?}"
: "${taito_project:?}"

pod="${1:?}"
container="${2}"
command=("${@:3}")

# Change namespace
"${taito_plugin_path}/util/use-context.sh"

if [[ ${pod} != *"-"* ]]; then
  # Short pod name was given. Determine the full pod name.
  pod=$(kubectl get pods | grep "${taito_project}" | \
    sed -e "s/${taito_project}-//" | \
    grep "${pod}" | \
    head -n1 | awk "{print \"${taito_project}-\" \$1;}")
fi

if [[ "${container}" == "--" ]] || [[ "${container}" == "-" ]]; then
  # No container name was given. Determine container name.
  container=$(echo "${pod}" | sed -e 's/\([^0-9]*\)*/\1/;s/-[0-9].*$//')
fi

if [[ -z "${pod}" ]]; then
  echo
  echo "kubectl: Please give pod name as argument:"
  (${taito_setv:?}; kubectl get pods)
else
  # Kubernetes
  echo
  echo "-------------------------------------------------------------------"
  echo
  (${taito_setv:?}; kubectl exec -it "${pod}" -c "${container}" -- "${command[@]}")
fi

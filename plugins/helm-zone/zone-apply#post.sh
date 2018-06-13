#!/bin/bash
: "${taito_setv:?}"
: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"

name=${1}

# Initialize Helm
if "${taito_cli_path}/util/confirm-execution.sh" "helm-init" "${name}"; then
  "${taito_cli_path}/plugins/kubectl/util/use-context.sh" && \
  echo "Initializing helm..." && \
  # TODO: helm v3 will remove tiller so from what i understood the permissions will be by the user who apply it --> no need for service account
  kubectl apply -f "${taito_plugin_path}/resources/service-account.yaml" && \
  sleep 5 && \
  helm init --upgrade --service-account tiller
fi

# Deploy Helm charts
if [[ -d "./helm" ]]; then
  charts=($(cd helm && ls)) && \
  for chart in ${charts[@]}
  do
    if "${taito_cli_path}/util/confirm-execution.sh" "${chart}" "${name}"
    then
      # TODO support namespaces
      echo "- Deploying chart ${chart} using Helm"
      (
        ${taito_setv}
        helm dependency update "./helm/${chart}"
        helm upgrade --debug --install --namespace taito-zone \
          "${chart}" "./helm/${chart}"
      )
    fi
  done
fi

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

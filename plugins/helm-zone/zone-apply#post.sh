#!/bin/bash
: "${taito_setv:?}"
: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"

name=${1}

# Initialize Helm
if "${taito_cli_path}/util/confirm-execution.sh" "helm-init" "${name}" \
  "Init helm by installing/upgrading helm tiller on Kubernetes"
then
  "${taito_cli_path}/plugins/kubectl/util/use-context.sh" && \
  echo "Initializing helm..." && \
  # TODO: helm v3 will remove tiller so from what i understood the permissions will be by the user who apply it --> no need for service account
  kubectl apply -f "${taito_plugin_path}/resources/service-account.yaml" && \
  sleep 5 && \
  helm init --upgrade --service-account --tiller-tls-verify tiller && \
  # NOTE: --tiller-tls-verify added recently
  echo "Helm starting up. Please wait for a while..." && \
  sleep 15
fi

# Deploy Helm charts
if [[ -d "./helm" ]]; then
  charts=($(cd helm && ls)) && \
  for chart in ${charts[@]}
  do
    if "${taito_cli_path}/util/confirm-execution.sh" "${chart}" "${name}" \
      "Install helm chart ${chart} on Kubernetes"
    then
      # TODO support namespaces
      # TODO duplicate code with helm plugin
      echo "- Deploying chart ${chart} using Helm"
      deploy_options=""
      values_file="./helm/${chart}/values.yaml"
      values_tmp_file="./helm/${chart}/values-tmp.yaml"
      rm -f "${values_tmp_file}" &> /dev/null
      if [[ -f "${values_file}" ]]; then
        # Substitute environment variables in values.yaml
        perl -p -e 's/\$\{([^}]+)\}/defined $ENV{$1} ? $ENV{$1} : ""/eg' \
          "${values_file}" > "${values_tmp_file}"
        deploy_options="${deploy_options} -f ${values_tmp_file}"
      fi
      (
        ${taito_setv}
        helm dependency update "./helm/${chart}"
        helm upgrade --debug --install --namespace taito-zone \
          ${deploy_options} \
          "${chart}" "./helm/${chart}"
      )
      rm -f "${values_tmp_file}" &> /dev/null
    fi
  done
fi

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

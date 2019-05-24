#!/bin/bash
: "${taito_util_path:?}"
: "${taito_plugin_path:?}"
: "${taito_command:?}"

# Set default region just in case
export AWS_DEFAULT_REGION="${taito_provider_region:?}"

# Automatic authentication on 'env apply'
if [[ $taito_command == "env-apply" ]] && [[ "${taito_mode:-}" != "ci" ]]; then
  echo
  echo -e "${H1s}aws${H1e}"
  echo "Authenticating"
  "${taito_plugin_path}/util/auth.sh"
fi

# Authentication for CI
if [[ "${taito_mode:-}" == "ci" ]]; then
  # Ensure that AWS credentials exist
  if [[ ! "${AWS_ACCESS_KEY_ID}" ]]; then
    echo
    echo -e "${H1s}aws${H1e}"
    echo
    echo "ERROR: AWS_ACCESS_KEY_ID environment variable not set."
    echo "Configure AWS_ACCESS_KEY_ID in your CI/CD settings."
    exit 1
  fi
  if [[ ! "${AWS_SECRET_ACCESS_KEY}" ]]; then
    echo
    echo -e "${H1s}aws${H1e}"
    echo
    echo "ERROR: AWS_SECRET_ACCESS_KEY environment variable not set"
    echo "Configure AWS_SECRET_ACCESS_KEY in your CI/CD settings."
    exit 1
  fi

  # Container registry (ECR) authentication
  if [[ ${taito_commands_only_chain:-} == *"docker/"* ]]; then
    echo
    echo -e "${H1s}aws${H1e}"
    echo "Getting credentials for Elastic Container Registry"
    "${taito_plugin_path}/util/get-credentials-ecr.sh"
  fi && \

  # Kubernetes (EKS) authentication
  if [[ ${taito_commands_only_chain:-} == *"kubectl/"* ]] || \
     [[ ${taito_commands_only_chain:-} == *"helm/"* ]] || ( \
       [[ ${kubernetes_db_proxy_enabled:-} == "true" ]] && \
       [[ ${taito_requires_database_connection:-} == "true" ]] \
     ); then
    echo
    echo -e "${H1s}aws${H1e}"
    echo "Getting credentials for kubernetes"
    "${taito_plugin_path}/util/get-credentials-kube.sh"
  fi
fi && \

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"

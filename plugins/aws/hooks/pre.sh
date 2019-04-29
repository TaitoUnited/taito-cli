#!/bin/bash
: "${taito_util_path:?}"
: "${taito_plugin_path:?}"

# Authentication for CI
if [[ "${taito_mode:-}" == "ci" ]]; then
  # Ensure that AWS credentials exist
  if [[ ! "${AWS_ACCESS_KEY_ID}" ]]; then
    echo "ERROR: AWS_ACCESS_KEY_ID environment variable not set."
    echo "Configure AWS_ACCESS_KEY_ID in your CI/CD settings."
    exit 1
  fi
  if [[ ! "${AWS_SECRET_ACCESS_KEY}" ]]; then
    echo "ERROR: AWS_SECRET_ACCESS_KEY environment variable not set"
    echo "Configure AWS_SECRET_ACCESS_KEY in your CI/CD settings."
    exit 1
  fi

  # Container registry (ECR) authentication
  if [[ ${taito_commands_only_chain:-} == *"docker/"* ]]; then
    echo
    echo "Getting credentials for Elastic Container Registry"
    "${taito_plugin_path}/util/get-credentials-ecr.sh"
  fi && \

  # Kubernetes (EKS) authentication
  if [[ ${taito_commands_only_chain:-} == *"kubectl/"* ]] || \
     [[ ${taito_commands_only_chain:-} == *"helm/"* ]]; then
    echo
    echo "### aws/pre: Getting credentials for kubernetes"
    "${taito_plugin_path}/util/get-credentials-kube.sh"
  fi
fi && \

# DB proxy
if [[ ${taito_commands_only_chain:-} == *"-db/"* ]]; then
  proxy_running=$(pgrep "cloud_sql_proxy")
  if [[ "${proxy_running:-}" == "" ]]; then
    echo
    echo "### aws/pre: Starting db proxy"
    echo "TODO implement"
  else
    echo
    echo "### aws/pre: Not Starting db proxy. It is already running."
  fi
fi && \

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"

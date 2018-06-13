#!/bin/bash
: "${taito_cli_path:?}"

name=${1}

if "${taito_cli_path}/util/confirm-execution.sh" "gcloud-auth" "${name}"; then
  if [[ -n "${kubectl_name:-}" ]]; then
    echo "Authenticating to Kubernetes: ${kubectl_name:-}"
    "${taito_cli_path}/plugins/gcloud/util/get-credentials-kube.sh"
  fi
fi && \

if "${taito_cli_path}/util/confirm-execution.sh" "gcloud-init" "${name}"; then
  echo "Cloud container builder rights:" && \
  echo && \
  echo "Add the following roles for service account XXX@cloudbuild.gserviceaccount.com" && \
  echo "so that the container builder is allowed to execute Kubernetes" && \
  echo "deployments and database migrations." && \
  echo && \
  echo "- Cloud SQL Client" && \
  echo "- Kubernetes Engine Developer"
fi && \

if "${taito_cli_path}/util/confirm-execution.sh" "gcloud-builder" "${name}"
then
  echo "TODO implement: function that sends notifications on build fail"
fi && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

#!/bin/bash
: "${taito_cli_path:?}"

name=${1}

if [[ -n "${kubectl_name:-}" ]]; then
  if "${taito_cli_path}/util/confirm-execution.sh" "gcloud-auth" "${name}" \
    "Authenticate to gcloud Kubernetes ${kubectl_name:-}"
  then
      "${taito_cli_path}/plugins/gcloud/util/get-credentials-kube.sh"
  fi
fi && \

if "${taito_cli_path}/util/confirm-execution.sh" "gcloud-builder" "${name}" \
  "Initialize cloud container builder"
then
  echo "Add the following roles for service account XXX@cloudbuild.gserviceaccount.com"
  echo "so that the container builder is allowed to execute Kubernetes"
  echo "deployments and database migrations."
  echo
  echo "- Cloud SQL Client"
  echo "- Kubernetes Engine Developer"
  echo
  echo "TODO move implementation here: function that sends notifications on build fail"
fi && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

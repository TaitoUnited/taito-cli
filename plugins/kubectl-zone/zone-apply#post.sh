#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"

name=${1}

"${taito_cli_path}/plugins/kubectl/util/use-context.sh"

if "${taito_cli_path}/util/confirm-execution.sh" "kubectl-dashboard" "${name}" \
  "Stop dashboard of Kubernetes as it is not needed in most cloud setups"
then
  kubectl scale --replicas=0 --namespace kube-system deployment/kubernetes-dashboard || :
fi && \

if "${taito_cli_path}/util/confirm-execution.sh" "kubectl-devops-namespace" "${name}" \
  "Create 'devops' namespace on Kubernetes"
then
  "${taito_plugin_path}/../kubectl/util/ensure-namespace.sh" devops
fi && \

# if "${taito_cli_path}/util/confirm-execution.sh" "kubectl-cloudsql-secret" "${name}" \
#   "Create service acccount for Cloud SQL access and save it to devops namespace"
# then
#   echo && \
#   echo "Service account for database access:" && \
#   echo && \
#   echo "Create a service account with role 'Cloud SQL Client' and save the" && \
#   echo "service account JSON key to file './tmp/cloudsql.json'." && \
#   echo "The service account will be used to access database from Kubernetes." && \
#   echo "You can delete the JSON file afterwards." && \
#   # TODO open gcloud console
#   echo "Press enter after you have saved the file." && \
#   read -r && \
#   kubectl create secret generic "cloudsql-gserviceaccount" --namespace=devops \
#     --from-file=key="tmp/cloudsql.json"
# fi && \

# TODO GitHub token handling should be implemented somewhere else?
if "${taito_cli_path}/util/confirm-execution.sh" "kubectl-github-secret" "${name}" \
  "Save GitHub token to devops namespace for tagging releases"
then
  echo && \
  echo "GitHub token for tagging releases:" && \
  echo && \
  echo "Save your personal GitHub token to file './tmp/github'." && \
  echo "It will be used for tagging git releases. You can delete the file afterwards." && \
  echo "Press enter after you have saved the file." && \
  read -r && \
  kubectl create secret generic "github-buildbot" --namespace=devops \
    --from-file=token=tmp/github
fi

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

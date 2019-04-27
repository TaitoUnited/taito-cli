#!/bin/bash -e
: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"

# name=${1}

"${taito_cli_path}/plugins/kubectl/util/use-context.sh"

# TODO: Already stopped on gcloud?
# if "${taito_cli_path}/util/confirm-execution.sh" "kubectl-dashboard" "${name}" \
#   "Stop dashboard of Kubernetes as it is not needed in most cloud setups"
# then
#   kubectl scale --replicas=0 --namespace kube-system deployment/kubernetes-dashboard || :
#   echo "NOTE: It's ok if this failed to 'not found' error."
#   echo
# fi

# TODO: Only needed if database manager and github token are saved on Kubernetes.
# But extra namespace does not matter either.
# if "${taito_cli_path}/util/confirm-execution.sh" "kubectl-devops-namespace" "${name}" \
#   "Create 'devops' namespace on Kubernetes"
# then
#   "${taito_plugin_path}/../kubectl/util/ensure-namespace.sh" devops
# fi

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

# TODO: GitHub token handling should be implemented somewhere else, but might be
# needed on Kubernetes for some setups.
# if "${taito_cli_path}/util/confirm-execution.sh" "kubectl-github-secret" "${name}" \
#   "ONLY FOR PRODUCTION CLUSTER: Save GitHub token to devops namespace for tagging releases"
# then
#   echo && \
#   echo "GitHub token for tagging releases:" && \
#   echo && \
#   echo "Save your personal GitHub token to file './tmp/github'." && \
#   echo "It will be used for tagging git releases. You can delete the file afterwards." && \
#   echo "Press enter after you have saved the file." && \
#   read -r && \
#   kubectl create secret generic "github-buildbot" --namespace=devops \
#     --from-file=token=tmp/github
# fi

echo
echo "--- LOAD BALANCER IP ADDRESSES ---"
echo
lb_ips="$(kubectl get services -o=custom-columns=LOAD_BALANCER_IP:.spec.loadBalancerIP,LOAD_BALANCER_AP:.status.loadBalancer.ingress[0].hostname \
  --no-headers --all-namespaces 2> /dev/null | grep -v "<none>.*<none>" | sed s/\\s*\<none\>\\s*//g)"
if [[ "${lb_ips}" ]]; then
  echo "${lb_ips}"
  echo
  echo "Your load balancer IP addresses are presented above. You should configure"
  echo "DNS for them if you have not done so already. If a hostname is shown above"
  echo "instead of an IP, you can resolve the IP by running 'taito -- host HOSTNAME'".
  echo "Example DNS entry:"
  echo
  echo "          A  *.mydomain.com  ->  123.123.123.123"
  echo
  echo "Press enter to continue"
  read -r
else
  echo "Your Kubernetes cluster does not seem to contain any load balancer IP"
  echo "addresses. Therefore none of the services are reachable from outside"
  echo "of the cluster. Once this command execution ends, you should install"
  echo "nginx-ingress, ambassador, or some other ingress controller to your"
  echo "Kubernetes cluster. You can install them by configuring helm releases"
  echo "in taito-config.sh and running 'taito zone apply' again."
  echo
  echo "If you just installed the ingress controller, wait for a couple of"
  echo "minutes and then run 'taito zone status' to see if your Kubernetes"
  echo "cluster have received a load balancer IP. Then configure DNS for the"
  echo "load balancer IP according to instructions given by 'taito zone status'"
  echo
  echo "Press enter to continue"
  read -r
fi

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

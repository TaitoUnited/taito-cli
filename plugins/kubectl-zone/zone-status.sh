#!/bin/bash
: "${taito_cli_path:?}"

"${taito_cli_path}/plugins/kubectl/util/use-context.sh"

echo --- Cluster ---
kubectl get componentstatus
echo
echo --- Nodes ---
kubectl describe nodes
echo
echo --- Top nodes ---
kubectl top nodes 2> /dev/null
echo
echo --- Ingresses ---
kubectl get ingress --all-namespaces
echo
echo --- Services ---
kubectl get services --all-namespaces
echo
echo --- Pods ---
kubectl get pods --all-namespaces
echo
echo --- Top pods ---
kubectl top pods --all-namespaces 2> /dev/null
echo
echo --- Load Balancer IPs ---
kubectl get services -o=custom-columns=LOAD_BALANCER_IP:.spec.loadBalancerIP,LOAD_BALANCER_AP:.status.loadBalancer.ingress[0].hostname \
  --no-headers --all-namespaces 2> /dev/null | \
  grep -v "<none>.*<none>" | \
  sed s/\\s*\<none\>\\s*//g
echo
echo "Your load balancer IP addresses are presented above. You should configure"
echo "DNS for them, and also set 'taito_default_domain' in taito-config.sh,"
echo "if you have not done so already. Example DNS entry:"
echo
echo "          A  *.mydomain.com  ->  123.123.123.123"
echo
echo "NOTE: If a hostname is shown instead of an IP, wait for a few minutes to"
echo "make sure that a static IP has been reserved for the hostname. Then resolve"
echo "the IP by running 'taito -- host HOSTNAME' and add a DNS entry for that IP."

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

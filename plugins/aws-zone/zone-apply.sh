#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"

# TODO authenticate to Kubernetes
echo $(terraform output kubeconfig) > ~/.kube/eksconfig
export KUBECONFIG=~/.kube/eksconfig

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

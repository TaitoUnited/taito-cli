#!/bin/bash

: "${taito_project:?}"
: "${taito_env:?}"

echo "- ${taito_project_env}-bucket"
kubectl delete secret "${taito_project_env}-bucket" 2> /dev/null

echo "- ${taito_project_env}-basic-auth"
kubectl delete secret "${taito_project_env}-basic-auth" 2> /dev/null

secret_index=0
secret_names=(${taito_secret_names})
for secret_name in "${secret_names[@]}"
do
  . "${taito_cli_path}/util/secret-by-index.sh"
  kubectl delete secret "${secret_name}" --namespace="${secret_namespace}"
  echo "- ${secret_name} deleted"
  secret_index=$((${secret_index}+1))
done

echo

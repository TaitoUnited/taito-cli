#!/bin/bash
: "${taito_util_path:?}"
: "${taito_plugin_path:?}"
: "${taito_project_path:?}"

export taito_proxy_credentials_file=/project/tmp/secrets/proxy_credentials.json
export taito_proxy_credentials_local_file="$taito_project_path/tmp/secrets/proxy_credentials.json"

taito_proxy_secret_name=
taito_proxy_secret_key=
if [[ ${taito_ci_provider:-} == "gcp" ]]; then
  taito_proxy_secret_name=gcp-proxy-gserviceaccount
  taito_proxy_secret_key=key
fi

if [[ $taito_proxy_secret_name ]]; then
  echo "Getting proxy secret (devops/$taito_proxy_secret_name.$taito_proxy_secret_key) from Kubernetes"
  mkdir -p "$taito_project_path/tmp/secrets"
  kubectl get secret "$taito_proxy_secret_name" -o yaml --namespace devops 2> /dev/null | \
    grep "^  $taito_proxy_secret_key:" | \
    sed -e "s/^.*: //" | base64 --decode > "$taito_proxy_credentials_local_file"
  [[ -s "$taito_proxy_credentials_local_file" ]] || \
    echo "WARNING: Failed to get the proxy secret from Kubernetes"
fi

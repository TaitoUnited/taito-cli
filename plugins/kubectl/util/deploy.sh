#!/bin/bash

: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${taito_customer:?}"
: "${taito_env:?}"
: "${taito_project:?}"
: "${taito_repo_name:?}"

image="${1}"
options=("${@:2}")

# Change namespace
"${taito_plugin_path}/util/use-context.sh"

# Read version number that semantic-release wrote on the package.json
version=$(grep "version" "${taito_project_path}/package.json" | \
  grep -o "[0-9].[0-9].[0-9]")

# Determine image
if [[ ${image} == "--dry-run" ]]; then
  # TODO: this is a quick hack
  options=("${@:1}")
  image="DRY_RUN"
elif [[ -z "${image}" ]]; then
  # Image not given as param
  echo "--- Determining the latest image tag for ${taito_project_env} ---"
  image=$(gcloud container builds list --limit=100 --filter='STATUS=SUCCESS' | \
    grep "${taito_repo_name}@${taito_branch}" | \
    sed 's/.*:\(.*\).*/\1 /g' | \
    cut -d ' ' -f 1 | head -n1)
fi

if [[ -z ${image} ]]; then
  echo "ERROR: Image not found"
  exit 1
fi

# Execute

# helm-ENV.yaml overrides default settings of helm.yaml
override_file=""
if [[ -f "scripts/helm-${taito_env}.yaml" ]]; then
  override_file="-f scripts/helm-${taito_env}.yaml"
fi

echo "- Deploying ${image} of ${taito_project_env} using Helm"

echo "helm upgrade \"${options[@]}\" --debug --install \
  --namespace \"${taito_namespace}\" \
  --set env=\"${taito_env}\" \
  --set project.name=\"${taito_project}\" \
  --set project.customer=\"${taito_customer}\" \
  --set build.imageTag=\"${image}\" \
  --set build.version=\"${version}\" \
  --set build.commit=\"TODO\" \
  -f scripts/helm.yaml ${override_file} \
  \"${taito_project_env}\" \"./scripts/${taito_project}\" "

helm upgrade "${options[@]}" --debug --install \
  --namespace "${taito_namespace}" \
  --set env="${taito_env}" \
  --set project.name="${taito_project}" \
  --set project.customer="${taito_customer}" \
  --set build.imageTag="${image}" \
  --set build.version="${version}" \
  --set build.commit="TODO" \
  -f scripts/helm.yaml ${override_file} \
  "${taito_project_env}" "./scripts/${taito_project}"

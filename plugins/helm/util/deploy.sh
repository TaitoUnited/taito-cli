#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${taito_namespace:?}"
: "${taito_zone:?}"
: "${taito_env:?}"
: "${taito_branch:?}"
: "${taito_project:?}"
: "${taito_project_path:?}"
: "${taito_repo_name:?}"

image="${1}"
options=("${@:2}")

# Read version number that semantic-release wrote on the package.json
version=$(grep "version" \
  "${taito_project_path}/package.json" | grep -o "[0-9].[0-9].[0-9]")

# Determine image
if [[ ${image} == "--dry-run" ]]; then
  # TODO: this is a quick hack
  options=("${@:1}")
  image="DRY_RUN"
elif [[ -z "${image}" ]]; then
  # Image not given as param -> use latest.
  image="latest"
fi

if [[ -z ${image} ]]; then
  echo "ERROR: Image not found"
  exit 1
fi

# Deploy chart located in ./scripts/helm

if [[ -d "./scripts/helm" ]]; then
  # helm-ENV.yaml overrides default settings of helm.yaml
  override_file=""
  if [[ -f "scripts/helm-${taito_env}.yaml" ]]; then
    override_file="-f scripts/helm-${taito_env}.yaml"
  fi

  echo "- Deploying ${image} of ${taito_project}-${taito_env} using Helm"
  (
    ${taito_setv:?}
    helm init --client-only
    helm dependency update "./scripts/helm"
    helm upgrade "${options[@]}" --debug --install \
      --namespace "${taito_namespace}" \
      --set env="${taito_env}" \
      --set zone.name="${taito_zone}" \
      --set zone.provider="${taito_provider:-}" \
      --set zone.namespace="${taito_namespace}" \
      --set zone.resourceNamespace="${taito_resource_namespace:-}" \
      --set project.name="${taito_project}" \
      --set project.company="${taito_company:-}" \
      --set project.family="${taito_family:-}" \
      --set project.application="${taito_application:-}" \
      --set project.suffix="${taito_suffix:-}" \
      --set build.imageTag="${image}" \
      --set build.version="${version}" \
      --set build.commit="TODO" \
      -f scripts/helm.yaml ${override_file} \
      ${helm_deploy_options:-} \
      "${taito_project}-${taito_env}" "./scripts/helm"
  )
fi

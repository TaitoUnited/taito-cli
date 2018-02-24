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
  # Image not given as param
  echo "--- Determining the latest image tag for ${taito_project}-${taito_env} ---"
  # TODO this should be in gcloud-builder plugin
  # --> just call: 'taito image show'?
  image=$(gcloud container builds list \
      --limit=100 --filter='STATUS=SUCCESS' | \
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

# Determine helm chart path
chart_path="./scripts/helm"
if [[ -d "./scripts/${taito_project}" ]]; then
  chart_path="./scripts/${taito_project}"
fi

echo "- Deploying ${image} of ${taito_project}-${taito_env} using Helm"

(
  ${taito_setv:?}
  helm upgrade "${options[@]}" --debug --install \
    --namespace "${taito_namespace}" \
    --set env="${taito_env}" \
    --set zone.name="${taito_zone}" \
    --set zone.provider="${taito_provider:-}" \
    --set project.name="${taito_project}" \
    --set project.company="${taito_company:-}" \
    --set project.family="${taito_family:-}" \
    --set project.application="${taito_application:-}" \
    --set project.suffix="${taito_suffix:-}" \
    --set build.imageTag="${image}" \
    --set build.version="${version}" \
    --set build.commit="TODO" \
    -f scripts/helm.yaml ${override_file} \
    "${taito_project}-${taito_env}" "${chart_path}"
)

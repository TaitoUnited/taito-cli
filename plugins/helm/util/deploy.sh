#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${taito_namespace:?}"
: "${taito_zone:?}"
: "${taito_env:?}"
: "${taito_target_env:?}"
: "${taito_branch:?}"
: "${taito_project:?}"
: "${taito_project_path:?}"
: "${taito_vc_repository:?}"

image="${1}"
options=("${@:2}")

# Determine image
# TODO: this is a quick hack
if [[ "${taito_mode:-}" == "ci" ]] && [[ ! -f ./taitoflag_images_exist ]]; then
  image="${image}-untested"
elif [[ ${image} == "--dry-run" ]]; then
  options=("${@:1}")
  image="DRY_RUN"
elif [[ -z "${image}" ]]; then
  # Image not given as param and using 'latest' causes problems
  echo "ERROR: image tag not given"
  echo "Later image tag will be determined automatically but until then"
  echo "image tag is mandatory"
  exit 1
fi

if [[ -z ${image} ]]; then
  echo "ERROR: Image not found"
  exit 1
fi

export taito_build_image_tag="${image}"
export taito_build_version=$(cat "${taito_project_path}/taitoflag_version" 2> /dev/null)

# Deploy chart located in ./scripts/helm
if [[ -d "./scripts/helm" ]]; then
  helm_deploy_options="${helm_deploy_options:-}"

  # Substitute environment variables in helm.yaml
  perl -p -e 's/\$\{([^}]+)\}/defined $ENV{$1} ? $ENV{$1} : ""/eg' \
    scripts/helm.yaml > scripts/helm.yaml.tmp

  # helm-ENV.yaml overrides default settings of helm.yaml
  override_file=""
  if [[ -f "scripts/helm-${taito_target_env}.yaml" ]]; then
    override_file="scripts/helm-${taito_target_env}.yaml"
  elif [[ -f "scripts/helm-${taito_env}.yaml" ]]; then
    override_file="scripts/helm-${taito_env}.yaml"
  fi
  if [[ ${override_file} ]]; then
    # Substitute environment variables in helm-ENV.yaml
    perl -p -e 's/\$\{([^}]+)\}/defined $ENV{$1} ? $ENV{$1} : ""/eg' \
      "${override_file}" > "${override_file}.tmp"
    helm_deploy_options="${helm_deploy_options} -f ${override_file}.tmp"
  fi

  echo "- Deploying ${image} of ${taito_project}-${taito_target_env} using Helm"
  (
    ${taito_setv:?}
    helm init --client-only
    helm dependency update "./scripts/helm"
    # TODO remove non-globals
    helm upgrade "${options[@]}" --debug --install \
      --namespace "${taito_namespace}" \
      --set global.env="${taito_target_env}" \
      --set global.zone.name="${taito_zone}" \
      --set global.zone.provider="${taito_provider:-}" \
      --set global.zone.providerRegion="${taito_provider_region:-}" \
      --set global.zone.providerZone="${taito_provider_zone:-}" \
      --set global.zone.namespace="${taito_namespace}" \
      --set global.zone.resourceNamespace="${taito_resource_namespace:-}" \
      --set global.project.name="${taito_project}" \
      --set global.project.company="${taito_company:-}" \
      --set global.project.family="${taito_family:-}" \
      --set global.project.application="${taito_application:-}" \
      --set global.project.suffix="${taito_suffix:-}" \
      --set global.build.imageTag="${image}" \
      --set global.build.version="${version}" \
      --set global.build.commit="TODO" \
      --set env="${taito_target_env}" \
      --set zone.name="${taito_zone}" \
      --set zone.provider="${taito_provider:-}" \
      --set zone.providerRegion="${taito_provider_region:-}" \
      --set zone.providerZone="${taito_provider_zone:-}" \
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
      -f scripts/helm.yaml.tmp \
      ${helm_deploy_options:-} \
      "${taito_project}-${taito_target_env}" "./scripts/helm"
  )

  rm -f scripts/*.tmp
fi

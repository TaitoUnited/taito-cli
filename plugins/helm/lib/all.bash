#!/bin/bash

function helm::deploy () {
  local image="${1:-$taito_target_image}"
  local options=("${@:2}")

  # Determine image
  # TODO: this is a quick hack
  if [[ ${taito_mode:-} == "ci" ]] && \
     [[ ${ci_exec_build:-} == "true" ]] && \
     [[ ${image} != *"-untested" ]] && \
     [[ ! -f ./taitoflag_images_exist ]]; then
    image="${image}-untested"
  elif [[ ${image} == "--dry-run" ]]; then
    options=("${@:1}")
    image="DRY_RUN"
  elif [[ -z "${image}" ]]; then
    # Image not given as param and using 'latest' causes problems
    echo "ERROR: image tag not given"
    exit 1
  fi

  if [[ -z ${image} ]]; then
    echo "ERROR: Image not found"
    exit 1
  fi

  export taito_build_image_tag="${image}"
  export taito_build_version=$(cat "${taito_project_path}/taitoflag_version" 2> /dev/null)

  function cleanup {
    rm -f scripts/*.tmp || :
    if helm version | grep "SemVer:\"v2." > /dev/null; then
      if [[ ${taito_zone} != "gcloud-temp1" ]]; then
        helm tiller stop > /dev/null || :
      fi
    fi
  }

  # Deploy chart located in ./scripts/helm
  # TODO: shoulfd we return with error code if ./scripts/helm not found?
  if [[ -d "./scripts/helm" ]]; then
    trap cleanup EXIT

    local helm_deploy_options="${helm_deploy_options:-}"

    echo > "${taito_vout:-}"
    echo "Helm does not support environment variables" > "${taito_vout}"
    echo "-> Substituting all environment variables in scripts/helm.yaml" > "${taito_vout}"
    sed 's/\$\$/%%-_-%%/g' scripts/helm.yaml | envsubst | sed 's/%%-_-%%/$/g' > scripts/helm.yaml.tmp || :
    echo "Substitution DONE" > "${taito_vout}"
    echo > "${taito_vout}"

    # helm-ENV.yaml overrides default settings of helm.yaml
    local override_file=""
    if [[ -f "scripts/helm-${taito_target_env}.yaml" ]]; then
      override_file="scripts/helm-${taito_target_env}.yaml"
    elif [[ -f "scripts/helm-${taito_env}.yaml" ]]; then
      override_file="scripts/helm-${taito_env}.yaml"
    fi
    if [[ ${override_file} ]]; then
      echo > "${taito_vout}"
      echo "Helm does not support environment variables" > "${taito_vout}"
      echo "-> Substituting all environment variables in ${override_file}" > "${taito_vout}"
      sed 's/\$\$/%%-_-%%/g' "${override_file}" | envsubst | sed 's/%%-_-%%/$/g' > "${override_file}.tmp" || :
      helm_deploy_options="${helm_deploy_options} -f ${override_file}.tmp"
      echo "Substitution DONE" > "${taito_vout}"
      echo > "${taito_vout}"
    fi

    # For Google Cloud builder
    if [[ ${taito_mode:-} == "ci" ]] && [[ ${HOME} == "/builder/home" ]]; then
      export HELM_HOME="/root/.helm"
    fi

    echo "Deploying ${image} of ${taito_project}-${taito_target_env} using Helm"
    echo
    echo > "${taito_vout}"
    cat ./scripts/helm.yaml.tmp > "${taito_vout}"
    echo > "${taito_vout}"
    (
      export taito_provider=${taito_orig_provider:-$taito_provider}
      taito::executing_start
      if helm version | grep "SemVer:\"v2." > /dev/null; then
        if [[ ${taito_zone} != "gcloud-temp1" ]]; then
          export HELM_TILLER_HISTORY_MAX=10
          helm tiller start-ci
          export HELM_HOST=127.0.0.1:44134
        fi
        helm init --client-only --history-max 10
      fi
      helm repo update
      helm dependency update "./scripts/helm"
      # TODO remove non-globals

      set +e
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
      exit_code=$?

      # NOTE: temp message for Helm v2 upgrade. TODO: remove this!
      if [[ $exit_code != 0 ]]; then
        echo "------------------------------------------------------------------------"
        echo "NOTE: Taito CLI is now using Helm v3. If the application was previously"
        echo "deployed with Helm v2, you can convert it to Helm v3 by running"
        echo "'taito helm2 convert:${taito_target_env}'. Alternatively you can delete the old Helm v2"
        echo "deployment with 'taito helm2 down:${taito_target_env}'. If you are using a persistent volume"
        echo "claim, you should backup your volume data before the operation."
        echo
        echo "TIP: If you get permissions errors on your CI/CD build after you have"
        echo "upgraded to Helm v3, either try to give your CI/CD user the appropriate"
        echo "user rights or disable the following settings from your helm chart:"
        echo
        echo "  rbacCreate: false"
        echo "  serviceAccountCreate: false"
        echo "  networkPolicyEnabled: false"
        echo "  podSecurityPolicyEnabled: false"
        echo
        echo "TIP: Once you have converted ALL deployments in your Kubernetes cluster"
        echo "to Helm v3 (including NGINX ingress), you may remove ALL Helm v2 data from"
        echo "Kubernetes cluster with 'taito helm2 dangerous cleanup everything:${taito_target_env}'."
        echo "WARNING: This operation cannot be reverted!"
        echo "------------------------------------------------------------------------"
      fi

      exit $exit_code
    )
  fi
}

function helm::run () {
  function finish {
    if helm version | grep "SemVer:\"v2." > /dev/null; then
      if [[ ${taito_zone} != "gcloud-temp1" ]]; then
        helm tiller stop > /dev/null
      fi
    fi
  }
  trap finish EXIT

  taito::executing_start
  if helm version | grep "SemVer:\"v2." > /dev/null; then
    if [[ ${taito_zone} != "gcloud-temp1" ]]; then
      export HELM_TILLER_HISTORY_MAX=10
      helm tiller start-ci
      export HELM_HOST=127.0.0.1:44134
    fi
  fi
  helm "${@}"
}

# Temporary Helm v2 support (TODO: remove once no longer needed)
function helm2::run () {
  function finish {
    if [[ ${taito_zone} != "gcloud-temp1" ]]; then
      helm2 tiller stop > /dev/null
    fi
  }
  trap finish EXIT

  taito::executing_start
  if [[ ${taito_zone} != "gcloud-temp1" ]]; then
    export HELM_TILLER_HISTORY_MAX=10
    helm2 tiller start-ci
    export HELM_HOST=127.0.0.1:44134
  fi
  helm2 "${@}"
}

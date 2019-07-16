#!/bin/bash

function helm::deploy () {
  local image="${1:-$taito_target_image}"
  local options=("${@:2}")

  # Determine image
  # TODO: this is a quick hack
  if [[ "${taito_mode:-}" == "ci" ]] && \
     [[ "${ci_exec_build:-}" == "true" ]] && \
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
    if [[ ${taito_zone} != "gcloud-temp1" ]]; then
      helm tiller stop > /dev/null || :
    fi
  }

  # Deploy chart located in ./scripts/helm
  # TODO: shoulfd we return with error code if ./scripts/helm not found?
  if [[ -d "./scripts/helm" ]]; then
    trap cleanup EXIT

    local helm_deploy_options="${helm_deploy_options:-}"

    echo > ${taito_vout}
    echo "Helm does not support environment variables" > ${taito_vout}
    echo "-> Substituting all environment variables in scripts/helm.yaml" > ${taito_vout}
    taito::substitute_variable_values_in_file scripts/helm.yaml scripts/helm.yaml.tmp
    echo "Substitution DONE" > ${taito_vout}
    echo > ${taito_vout}

    # helm-ENV.yaml overrides default settings of helm.yaml
    local override_file=""
    if [[ -f "scripts/helm-${taito_target_env}.yaml" ]]; then
      override_file="scripts/helm-${taito_target_env}.yaml"
    elif [[ -f "scripts/helm-${taito_env}.yaml" ]]; then
      override_file="scripts/helm-${taito_env}.yaml"
    fi
    if [[ ${override_file} ]]; then
      echo > ${taito_vout}
      echo "Helm does not support environment variables" > ${taito_vout}
      echo "-> Substituting all environment variables in ${override_file}" > ${taito_vout}
      taito::substitute_variable_values_in_file "${override_file}" "${override_file}.tmp"
      helm_deploy_options="${helm_deploy_options} -f ${override_file}.tmp"
      echo "Substitution DONE" > ${taito_vout}
      echo > ${taito_vout}
    fi

    # For Google Cloud builder
    if [[ "${taito_mode:-}" == "ci" ]] && [[ "${HOME}" == "/builder/home" ]]; then
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
      if [[ ${taito_zone} != "gcloud-temp1" ]]; then
        export HELM_TILLER_HISTORY_MAX=10
        helm tiller start-ci > /dev/null
        export HELM_HOST=127.0.0.1:44134
      fi
      helm init --client-only --history-max 10
      helm repo update
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

      # NOTE: temp fix for Kubernetes upgrade. TODO: remove this!
      exit_code=$?
      if [[ $exit_code != 0 ]] && [[ ${taito_zone} == "gcloud-temp1" ]] && \
         helm ls --namespace "${taito_namespace}" | grep "2017\|2018\|Jan\|Feb\|Mar\|Apr\|May"; then
        echo "Fix Helm chart after Kubernetes upgrade: delete chart and redeploy"
        kubectl delete configmap "${taito_project}-common" \
          --namespace "${taito_namespace}"
        kubectl delete configmap "${taito_project}-${taito_target_env}-common" \
          --namespace "${taito_namespace}"
        helm delete --purge "${taito_project}-${taito_target_env}"
        sleep 15
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
      fi
      exit $exit_code
    )
  fi
}

function helm::run () {
  function finish {
    if [[ ${taito_zone} != "gcloud-temp1" ]]; then
      helm tiller stop > /dev/null
    fi
  }
  trap finish EXIT

  taito::executing_start
  if [[ ${taito_zone} != "gcloud-temp1" ]]; then
    export HELM_TILLER_HISTORY_MAX=10
    helm tiller start-ci > /dev/null
    export HELM_HOST=127.0.0.1:44134
  fi
  helm "${@}"
}

#!/bin/bash -e

function kubectl::get_pods() {
  kubectl get pods ${2} | \
    ${1} | \
    grep "${prefix}" | \
    sed -e "s/${prefix}-//" | \
    grep "${taito_target}" | \
    head -n1 | awk "{print \"${prefix}-\" \$1;}"
}

function kubectl::expose_pod_and_container () {
  : "${taito_project:?}"
  : "${taito_target:?Target not given}"
  : "${taito_target_env:?}"

  local prefix="${taito_project}"
  if [[ "${taito_version:-}" -ge "1" ]]; then
    prefix="${taito_project}-${taito_target_env}"
  fi

  if [[ ${taito_target} != *"-"* ]]; then
    # Short pod name was given. Determine the full pod name.
    if [[ $DETERMINE_FAILED_POD = "true" ]]; then
      pod=$(kubectl::get_pods "grep -v Running")
    else
      pod=$(
        kubectl::get_pods \
          "grep -v CrashLoopBackOff" \
          "--field-selector=status.phase=Running"
      )
    fi
    if [[ ! ${pod} ]]; then
      pod=$(kubectl::get_pods "cat")
    fi
  fi

  if [[ -z "${container}" ]] || \
     [[ "${container}" == "--" ]] || \
     [[ "${container}" == "-" ]]; then
    # No container name was given. Determine container name.
    container=$(echo "${pod}" | \
      sed -e 's/\([^0-9]*\)*/\1/;s/-[a-z0-9]*-[a-z0-9]*$//' | \
      sed -e "s/-${taito_target_env}//")
  fi
}

function kubectl::expose_pods () {
  : "${taito_project:?}"
  : "${taito_target:?Target not given}"
  : "${taito_target_env:?}"

  local prefix="${taito_project}"
  if [[ "${taito_version:-}" -ge "1" ]]; then
    prefix="${taito_project}-${taito_target_env}"
  fi

  pods=$(
    kubectl get pods | \
    grep "${prefix}" | \
    sed -e "s/${prefix}-//" | \
    grep "${taito_target}" | \
    awk "{print \"${prefix}-\" \$1;}" | \
    tr '\n' ' '
  )
}

function kubectl::exec () {
  kubectl::use_context
  kubectl::expose_pod_and_container

  if [[ -z "${pod}" ]]; then
    echo
    echo "kubectl: Please give pod name as argument:"
    (${taito_setv:?}; kubectl get pods)
  else
    # Kubernetes
    (${taito_setv:?}; kubectl exec -it "${pod}" -c "${container}" -- "${@}")
  fi
}

function kubectl::restart_all () {
  if [[ ${kubernetes_skip_restart:-} != "true" ]]; then
    echo
    if taito::confirm "Restart all pods in namespace ${taito_namespace}?"; then
      echo "Restarting pods"
      echo "TODO rolling update instead of delete?"
      (${taito_setv:?}; kubectl delete --all pods --namespace="${taito_namespace}")
    fi
  fi
}

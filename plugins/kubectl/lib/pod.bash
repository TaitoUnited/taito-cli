#!/bin/bash -e

function kubectl::get_pods() {
  filter_command=$1
  kube_flags=$2
  pod_index=${3:-0}

  kubectl get pods ${kube_flags} | \
    ${filter_command} | \
    grep "${prefix}" | \
    sed -e "s/${prefix}-//" | \
    grep "${taito_target}" | \
    sed -n $((pod_index + 1))p | \
    awk "{print \"${prefix}-\" \$1;}"
}

function kubectl::expose_pod_and_container () {
  : "${taito_project:?}"
  : "${taito_target:?Target not given}"
  : "${taito_target_env:?}"

  determine_failed_pod=${1}
  pod_index=${2}

  local prefix="${taito_project}"
  if [[ ${taito_version:-} -ge "1" ]]; then
    prefix="${taito_project}-${taito_target_env}"
  fi

  if [[ ${taito_target} != *"-"* ]]; then
    # Short pod name was given. Determine the full pod name.
    if [[ ${determine_failed_pod} == "true" ]] && [[ ! ${pod_index} ]]; then
      pod=$(kubectl::get_pods "grep -v Running")
    else
      pod=$(
        kubectl::get_pods \
          "grep -v CrashLoopBackOff" \
          "--field-selector=status.phase=Running" \
          "${pod_index}"
      )
    fi
    if [[ ! ${pod} ]]; then
      pod=$(kubectl::get_pods "cat")
    fi
  fi

  if [[ -z "${container}" ]] || \
     [[ ${container} == "--" ]] || \
     [[ ${container} == "-" ]]; then
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
  if [[ ${taito_version:-} -ge "1" ]]; then
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
  if [[ $1 =~ ^[0-9]+$ ]]; then
    pod_index="${1}"
    shift
  fi

  kubectl::use_context
  kubectl::expose_pod_and_container false "${pod_index}"

  if [[ -z "${pod}" ]]; then
    echo
    echo "kubectl: Please give pod name as argument:"
    (taito::executing_start; kubectl get pods)
  else
    # Kubernetes
    (taito::executing_start; kubectl exec -it "${pod}" -c "${container}" -- "${@}")
  fi
}

function kubectl::restart_all () {
  if [[ ${kubernetes_skip_restart:-} != "true" ]]; then
    echo
    if taito::confirm "Restart all pods in namespace ${taito_namespace}?"; then
      echo "Restarting pods"
      echo "TODO rolling update instead of delete?"
      (taito::executing_start; kubectl delete --all pods --namespace="${taito_namespace}")
    fi
  fi
}

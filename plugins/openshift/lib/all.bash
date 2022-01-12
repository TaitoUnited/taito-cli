#!/bin/bash

function openshift::authenticate () {
  local options=" ${*} "
  local url="${openshift_url:-}"
  if [[ ! ${url} ]] && [[ ${kubernetes_name:-} ]]; then
    url="https://${kubernetes_name}"
  fi

  if [[ ${options} == *" --reset "* ]] || \
     ! oc status | grep "${url:?}" &> /dev/null;
  then
    local token="${openshift_token}"
    if [[ ! ${openshift_certificate_file} ]] && [[ ! ${openshift_password} ]]; then
      echo "OPTIONAL: Enter token for token based login."
      read -s token
      echo
    fi

    if [[ ${openshift_certificate_file} ]]; then
      (
        taito::executing_start
        oc login "${url:?}" \
          --certificate-authority="${openshift_certificate_file}"
      )
    elif [[ ${token:-} ]]; then
      (
        taito::executing_start
        oc login "${url:?}" --token="${token}"
      )
    else
      (
        taito::executing_start
        oc login "${url:?}" \
          --username="${openshift_username:-}" \
          --password="${openshift_password:-}"
      )
    fi
  fi
}

function openshift::authenticate_on_container_registry () {
  local url="${openshift_registry_url:-}"
  if [[ ! ${url} ]] && [[ ${kubernetes_name:-} ]]; then
    url="${kubernetes_name}:5000"
  fi

  taito::executing_start
  # TODO: avoid passing password via CLI
  docker login -u openshift -p $(oc whoami -t) "${url}"
}

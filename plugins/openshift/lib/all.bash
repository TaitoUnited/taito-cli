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
    if [[ ${openshift_certificate_file:-} ]]; then
      (
        taito::executing_start
        oc login "${url:?}" \
          --certificate-authority="${openshift_certificate_file}"
      )
    elif [[ ${openshift_username} ]]; then
      (
        taito::executing_start
        oc login "${url:?}" \
          --username="${openshift_username:-}" \
          --password="${openshift_password:-}"
      )
    else
      (
        if [[ ! ${openshift_token:-} ]]; then
          read openshift_token
        fi
        taito::executing_start
        echo oc login "${url:?}" --token="${openshift_token}"
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

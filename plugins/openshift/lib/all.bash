#!/bin/bash

function openshift::authenticate () {
  local options=" ${*} "
  local url="${openshift_url:-}"
  if [[ ! ${url} ]] && [[ ${kubernetes_name:-} ]]; then
    url="http://${kubernetes_name}"
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
    elif [[ ${openshift_token:-} ]]; then
      (
        taito::executing_start
        oc login "${url:?}" --token="${openshift_token}"
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

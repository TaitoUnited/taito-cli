#!/bin/bash

function openshift::authenticate () {
  local options=" ${*} "

  if [[ ${options} == *" --reset "* ]] || \
     ! oc status | grep "${openshift_url:?}" &> /dev/null;
  then
    if [[ ${openshift_certificate_file:-} ]]; then
      oc login "${openshift_url:?}" \
        --certificate-authority="${openshift_certificate_file}"
    elif [[ ${openshift_token:-} ]]; then
      oc login "${openshift_url:?}" \
        --token="${openshift_token}"
    else
      oc login "${openshift_url:?}" \
        --username="${openshift_username:-}" \
        --password="${openshift_password:-}"
    fi
  fi
}

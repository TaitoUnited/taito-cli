#!/bin/bash -e

function kubectl::print_resources() {
  type=$1
  prefix="${taito_project:?}-${taito_target_env:?}"
  kubectl get "${type}" | grep "${prefix}" | cut -d' ' -f1
}

function kubectl::delete_resources() {
  type=$1
  echo "Deleting all ${type}s"
  kubectl::print_resources "${type}" | xargs kubectl delete "${type}"
}

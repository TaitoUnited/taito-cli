#!/bin/bash

function gcp-run::select_services () {
  : "${taito_zone:?}" "${taito_provider_region:?}"
  : "${taito_project:?}" "${taito_target_env:?}"

  local handler
  for handler in ${taito_commands_only_chain:-}; do
    if [[ ${handler} == */kubectl/* ]] || [[ ${handler} == */docker-compose/* ]]; then
      echo "ERROR: Enable only one runtime plugin per environment." >&2
      return 1
    fi
  done

  if [[ ${taito_target:-} ]] && ! taito::is_current_target_of_type container; then
    echo "ERROR: Unknown Cloud Run container '${taito_target}'." >&2
    return 1
  fi

  gcp_run_services=()
  local target
  for target in ${taito_target:-${taito_containers:-}}; do
    gcp_run_services+=("${taito_project}-${taito_target_env}-${target}")
  done
  if [[ ${#gcp_run_services[@]} == 0 ]]; then
    echo "ERROR: No Cloud Run containers configured." >&2
    return 1
  fi
}

function gcp-run::describe_service () {
  gcloud run services describe "${1:?}" \
    --project "${taito_zone:?}" --region "${taito_provider_region:?}" \
    --format=json || {
      echo "ERROR: Could not describe Cloud Run service '${1}'." >&2
      return 1
    }
}

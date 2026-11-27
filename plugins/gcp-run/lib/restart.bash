#!/bin/bash

function gcp-run::restart_image () {
  local service=${1:?}
  local description=${2:?}
  local revision
  local deployed
  if ! jq -e '
    .status.latestReadyRevisionName as $revision |
    ($revision != null) and
    (.status.latestCreatedRevisionName == $revision) and
    (.status.observedGeneration == .metadata.generation) and
    any(.status.conditions[]?; .type == "Ready" and .status == "True") and
    (.spec.template.spec.containers | length == 1) and
    all(.spec.template.spec.containers[0].env[]?;
      .name != "TAITO_RESTART_NONCE" or .valueFrom == null) and
    (.spec.traffic | length == 1) and
    (.spec.traffic[0] | .latestRevision == true and .percent == 100 and .tag == null) and
    (.status.traffic | length == 1) and
    (.status.traffic[0] | .revisionName == $revision and .percent == 100 and .tag == null)
  ' <<< "${description}" > /dev/null; then
    echo "ERROR: ${service}: restart requires a ready single-container service with 100% untagged traffic following latest. Check 'taito status:${taito_target_env:?}' and Cloud Run traffic settings." >&2
    return 1
  fi
  revision=$(jq -er '.status.latestReadyRevisionName' <<< "${description}") || return 1
  deployed=$(gcloud run revisions describe "${revision}" \
    --project "${taito_zone:?}" --region "${taito_provider_region:?}" \
    --format=json) || return 1
  jq -er '
      select(any(.status.conditions[]?; .type == "Ready" and .status == "True")) |
      .status.imageDigest | select(test("^.+@sha256:[a-f0-9]{64}$"))
    ' <<< "${deployed}"
}

function gcp-run::restart_service () {
  local service=${1:?}
  local before=${2:?}
  local image=${3:?}
  local nonce=${4:?}
  local revision="${service}-r${nonce:0:12}"
  local description

  echo "Restarting ${service} as ${revision}"
  description=$(gcp-run::describe_service "${service}") || return 1
  if ! jq -e --argjson before "${before}" '
    .spec == $before.spec and .metadata.generation == $before.metadata.generation and
    .status == $before.status
  ' <<< "${description}" > /dev/null; then
    echo "ERROR: ${service} changed during restart; retry after deployment completes." >&2
    return 1
  fi

  (
    taito::executing_start
    gcloud run services update "${service}" \
      --project "${taito_zone:?}" --region "${taito_provider_region:?}" \
      --image "${image}" --revision-suffix "r${nonce:0:12}" \
      --update-env-vars "TAITO_RESTART_NONCE=${nonce}" \
      --format='value(status.latestReadyRevisionName)' > /dev/null
  ) || return 1

  description=$(gcp-run::describe_service "${service}") || return 1
  if ! jq -e --arg revision "${revision}" --arg nonce "${nonce}" '
    .status.latestReadyRevisionName == $revision and
    any(.spec.template.spec.containers[0].env[]?;
      .name == "TAITO_RESTART_NONCE" and .value == $nonce)
  ' <<< "${description}" > /dev/null ||
     [[ $(gcp-run::restart_image "${service}" "${description}") != "${image}" ]]; then
    echo "ERROR: ${service}: replacement ${revision} failed readiness, image, or traffic verification." >&2
    return 1
  fi
  echo "Ready: ${service} (${revision})"
}

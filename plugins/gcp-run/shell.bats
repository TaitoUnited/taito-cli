#!/usr/bin/env bats

load "${taito_cli_path}/test/util/test-helper"
load test-helper

enable_ssh() {
  export taito_target=server
  jq '.metadata.annotations["run.googleapis.com/ssh-enabled"] = "true"' \
    "${GCLOUD_SERVICE}" > "${GCLOUD_SERVICE}.tmp"
  mv "${GCLOUD_SERVICE}.tmp" "${GCLOUD_SERVICE}"
}

@test "gcp-run: shell connects to the selected service and serving revision" {
  enable_ssh
  test shell-40
  assert_status 0
  assert_output --partial 'SSH session'
  assert_executed call-next
  assert_equal "$(cat "${GCLOUD_CALLS}")" "run services describe chat-dev-server --project google-project --region europe-north1 --format=json
run revisions describe server-00001 --project google-project --region europe-north1 --format=json
beta run services ssh chat-dev-server --project google-project --region europe-north1 --revision server-00001"
}

@test "gcp-run: shell uses the PR environment" {
  enable_ssh
  export taito_target_env=pr-123
  test shell-40
  assert_status 0
  [[ $(cat "${GCLOUD_CALLS}") == *'services ssh chat-pr-123-server '* ]]
}

@test "gcp-run: shell preserves stdin and stdout" {
  enable_ssh
  export GCLOUD_READ_STDIN=true
  run bash -c 'printf "shell input\n" | "${taito_plugin_path}/shell-40"'
  assert_status 0
  assert_output --partial 'shell input'
}

@test "gcp-run: shell propagates connection failures and interruption" {
  enable_ssh
  for code in 1 130; do
    export GCLOUD_SSH_EXIT=${code}
    test shell-40
    assert_status "${code}"
    [[ ${output} != *'executed: call-next'* ]]
  done
}

@test "gcp-run: shell requires a configured container and rejects indexes" {
  test shell-40
  assert_status 1
  export taito_target=unknown
  test shell-40
  assert_status 1
  export taito_target=server
  test shell-40 0
  assert_status 1
  assert_equal "$(cat "${GCLOUD_CALLS}")" ""
}

@test "gcp-run: shell reports missing service or permission failures" {
  enable_ssh
  for failure in 'services describe' 'revisions describe'; do
    export GCLOUD_FAIL=${failure}
    test shell-40
    assert_status 1
    ! grep -q 'services ssh' "${GCLOUD_CALLS}"
  done
}

@test "gcp-run: shell does not enable SSH automatically" {
  export taito_target=server
  test shell-40
  assert_status 1
  assert_output --partial 'enable Cloud Run SSH before connecting'
  assert_equal "$(wc -l < "${GCLOUD_CALLS}" | xargs)" 1
}

@test "gcp-run: shell rejects ambiguous services" {
  enable_ssh
  cp "${GCLOUD_SERVICE}" "${GCLOUD_SERVICE}.base"
  for change in \
    '.status.traffic += [{revisionName: "other", percent: 10}]' \
    '.status.traffic = []'; do
    jq "${change}" "${GCLOUD_SERVICE}.base" > "${GCLOUD_SERVICE}"
    test shell-40
    assert_status 1
    ! grep -q 'services ssh' "${GCLOUD_CALLS}"
  done
}

@test "gcp-run: shell validates the serving revision instead of a newer sidecar template" {
  enable_ssh
  jq '
    .status.latestCreatedRevisionName = "server-00002" |
    .spec.template.spec.containers += [{image: "sidecar"}]
  ' "${GCLOUD_SERVICE}" > "${GCLOUD_SERVICE}.tmp"
  mv "${GCLOUD_SERVICE}.tmp" "${GCLOUD_SERVICE}"
  test shell-40
  assert_status 0
  [[ $(cat "${GCLOUD_CALLS}") == *'--revision server-00001'* ]]
}

@test "gcp-run: shell rejects unsupported serving revisions despite a supported template" {
  enable_ssh
  cp "${GCLOUD_REVISION}" "${GCLOUD_REVISION}.base"
  for change in \
    '.metadata.annotations["run.googleapis.com/execution-environment"] = "gen1"' \
    '.spec.containers += [{image: "sidecar"}]'; do
    jq "${change}" "${GCLOUD_REVISION}.base" > "${GCLOUD_REVISION}"
    test shell-40
    assert_status 1
    assert_output --partial 'server-00001: shell requires a second-generation, single-container revision'
    ! grep -q 'services ssh' "${GCLOUD_CALLS}"
  done
}

@test "gcp-run: dispatcher routes targeted PR shell" {
  enable_ssh
  mkdir -p "${BATS_TEST_TMPDIR}/project" "${BATS_TEST_TMPDIR}/home"
  export TAITO_HOME="${BATS_TEST_TMPDIR}/home"
  printf '%s\n' 'taito_plugins=gcp-run:-local' 'taito_env=dev' 'taito_environments=dev' \
    > "${BATS_TEST_TMPDIR}/project/taito-config.sh"
  cd "${BATS_TEST_TMPDIR}/project"
  run "${taito_cli_path}/src/execute-command" -q shell:server:pr-123
  assert_status 0
  assert_output --partial 'SSH session'
  [[ $(cat "${GCLOUD_CALLS}") == *'services ssh chat-pr-123-server '* ]]
}

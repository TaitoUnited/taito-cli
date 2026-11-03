#!/bin/bash

setup() {
  export taito_plugin_path="${BATS_TEST_DIRNAME}"
  export PATH="${taito_plugin_path}/mocks:${PATH}"
  export taito_lib_path="${taito_cli_path:?}/lib"
  # shellcheck source=../../lib/bash/all.bash
  . "${taito_lib_path}/bash/all.bash"
  function taito::call_next () { echo "executed: call-next ${*} :"; }
  export -f taito::call_next
  export taito_zone=google-project taito_provider_region=europe-north1
  export taito_project=chat taito_env=dev taito_target_env=dev
  export taito_containers="server worker" taito_target=""
  export taito_commands_only_chain="${taito_plugin_path}/status-40"
  export GCLOUD_CALLS="${BATS_TEST_TMPDIR}/gcloud.calls"
  export GCLOUD_SERVICE="${BATS_TEST_TMPDIR}/service.json"
  export GCLOUD_REVISION="${BATS_TEST_TMPDIR}/revision.json"
  cp "${taito_plugin_path}/fixtures/service.json" "${GCLOUD_SERVICE}"
  cp "${taito_plugin_path}/fixtures/revision.json" "${GCLOUD_REVISION}"
  touch "${GCLOUD_CALLS}"
}

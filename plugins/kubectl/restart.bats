#!/usr/bin/env bats

load "${taito_cli_path}/test/util/test-helper"

setup() {
  export taito_plugin_path="${BATS_TEST_DIRNAME}"
  export taito_lib_path="${taito_cli_path}/lib"
  export PATH="${taito_plugin_path}/mocks:${PATH}"
  . "${taito_lib_path}/bash/all.bash"
  export taito_project=chat taito_env=dev taito_target_env=dev taito_target=""
  export taito_containers=server taito_version=1 taito_dout=/dev/null
  export kubernetes_cluster=cluster taito_namespace=chat-dev
  function taito::call_next () { echo "executed: call-next ${*} :"; }
  export -f taito::call_next
}

@test "kubectl: restart deletes only application pods" {
  test restart-50
  assert_status 0
  assert_executed kubectl delete pods -l release=chat-dev
  assert_executed call-next
}

@test "kubectl: targeted restart deletes the selected pod" {
  export taito_target=server
  test restart-50 0
  assert_status 0
  assert_executed kubectl delete pod chat-dev-server-123-abc
  assert_executed call-next 0
}

#!/usr/bin/env bats

load "${taito_cli_path}/test/util/test-helper"

setup() {
  export taito_plugin_path="${BATS_TEST_DIRNAME}"
  export taito_lib_path="${taito_cli_path}/lib"
  export PATH="${taito_plugin_path}/mocks:${PATH}"
  . "${taito_lib_path}/bash/all.bash"
  export taito_env=local taito_target_env=local taito_target=""
  export taito_project=acme-chat taito_containers=server
  function taito::execute_on_host_fg () { bash -c "${1}"; }
  function taito::call_next () { echo "executed: call-next ${*} :"; }
  export -f taito::execute_on_host_fg taito::call_next
}

@test "docker-compose: 'taito restart'" {
  test restart-50
  assert_status 0

  assert_executed docker compose -f docker-compose.yaml stop
  assert_executed docker compose -f docker-compose.yaml up
  assert_executed call-next
  assert_executed_count 3
}

@test "docker-compose: 'taito restart:server'" {
  export taito_target="server"
  export taito_project="acme-chat"
  test restart-50
  assert_status 0

  assert_executed docker compose -f docker-compose.yaml restart acme-chat-server
  assert_executed call-next
  assert_executed_count 2
}

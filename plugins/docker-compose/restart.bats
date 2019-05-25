#!/usr/bin/env bats

load "${taito_cli_path}/test/util/test-helper.sh"

@test "docker-compose: 'taito restart'" {
  test restart.sh

  assert_executed docker-compose -f docker-compose.yaml stop
  assert_executed docker-compose -f docker-compose.yaml up
  assert_executed call-next.sh
  assert_executed_count 3
}

@test "docker-compose: 'taito restart:server'" {
  export taito_target="server"
  export taito_project="acme-chat"
  test restart.sh

  assert_executed docker-compose -f docker-compose.yaml restart acme-chat-server
  assert_executed call-next.sh
  assert_executed_count 2
}

#!/usr/bin/env bats

load "${taito_cli_path}/test/util/test-helper.sh"

@test "docker-compose: 'taito kill:server'" {
  export taito_target="server"
  export taito_project="acme-chat"
  test kill.sh

  assert_executed docker kill acme-chat-server
  assert_executed call-next.sh
  assert_executed_count 2
}

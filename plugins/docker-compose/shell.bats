#!/usr/bin/env bats

load "${taito_cli_path}/test/util/test-helper.sh"

@test "docker-compose: 'taito shell:server'" {
  export taito_target="server"
  export taito_project="acme-chat"
  test shell.sh

  assert_executed docker exec -it acme-chat-server /bin/sh
  assert_executed call-next.sh
  assert_executed_count 2
}

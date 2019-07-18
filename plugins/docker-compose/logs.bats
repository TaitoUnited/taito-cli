#!/usr/bin/env bats

load "${taito_cli_path}/test/util/test-helper"

@test "docker-compose: 'taito logs:server'" {
  export taito_target="server"
  export taito_project="acme-chat"
  test logs

  assert_executed docker logs -f --tail 400 acme-chat-server
  assert_executed call-next
  assert_executed_count 2
}

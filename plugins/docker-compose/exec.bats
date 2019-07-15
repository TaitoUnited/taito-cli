#!/usr/bin/env bats

load "${taito_cli_path}/test/util/test-helper"

@test "docker-compose: 'taito exec:server echo test'" {
  export taito_target="server"
  export taito_project="acme-chat"
  test exec echo test

  assert_executed docker exec -it acme-chat-server echo test
  assert_executed call-next echo test
  assert_executed_count 2
}

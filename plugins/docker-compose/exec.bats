#!/usr/bin/env bats

load "${BATS_TEST_DIRNAME}/../../test/util/test-helper.sh"

@test "docker-compose: 'taito exec:server echo test'" {
  export taito_target="server"
  export taito_project="acme-chat"
  test exec.sh echo test

  assert_executed docker exec -it acme-chat-server echo test
  assert_executed call-next.sh echo test
  assert_executed_count 2
}

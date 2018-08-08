#!/usr/bin/env bats

load "${BATS_TEST_DIRNAME}/../../test/util/test-helper.sh"

@test "docker-compose: 'taito logs:server'" {
  export taito_target="server"
  export taito_project="acme-chat"
  test logs.sh

  assert_executed docker logs -f --tail 400 acme-chat-server
  assert_executed call-next.sh
  assert_executed_count 2
}

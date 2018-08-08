#!/usr/bin/env bats

load "${BATS_TEST_DIRNAME}/../../test/util/test-helper.sh"

@test "docker-compose: 'taito commit:server'" {
  export taito_target="server"
  export taito_project="acme-chat"
  test commit.sh

  assert_executed docker ps
  assert_executed docker commit acme-chat-server acme-chat-server-savetus
  assert_executed docker image tag acme-chat-server-savetus acme-chat-server
  assert_executed call-next.sh
  assert_executed_count 4
}

#!/usr/bin/env bats

load "${BATS_TEST_DIRNAME}/../../test/util/test-helper.sh"

@test "docker-compose: 'taito copy from:server SOURCEPATH DESTPATH'" {
  export taito_target="server"
  export taito_project="acme-chat"
  test copy-from.sh SOURCEPATH DESTPATH

  assert_executed docker cp acme-chat-server:SOURCEPATH DESTPATH
  assert_executed call-next.sh SOURCEPATH DESTPATH
  assert_executed_count 2
}

#!/usr/bin/env bats

load "${taito_cli_path}/test/util/test-helper"

@test "docker-compose: 'taito copy from:server SOURCEPATH DESTPATH'" {
  export taito_target="server"
  export taito_project="acme-chat"
  test copy-from SOURCEPATH DESTPATH

  assert_executed docker cp acme-chat-server:SOURCEPATH DESTPATH
  assert_executed call-next SOURCEPATH DESTPATH
  assert_executed_count 2
}

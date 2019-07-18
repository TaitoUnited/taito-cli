#!/usr/bin/env bats

load "${taito_cli_path}/test/util/test-helper"

@test "docker-compose: 'taito copy to:server SOURCEPATH DESTPATH'" {
  export taito_target="server"
  export taito_project="acme-chat"
  test copy-to SOURCEPATH DESTPATH

  assert_executed docker cp SOURCEPATH acme-chat-server:DESTPATH
  assert_executed call-next SOURCEPATH DESTPATH
  assert_executed_count 2
}

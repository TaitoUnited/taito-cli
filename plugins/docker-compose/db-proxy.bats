#!/usr/bin/env bats

load "${taito_cli_path}/test/util/test-helper.sh"

@test "docker-compose: 'taito db proxy'" {
  export database_external_port="1234"
  export database_name="mydatabase"
  export database_username="myusername"
  export database_password="mypassword"
  test db-proxy.sh

  assert_output --partial "host: 127.0.0.1"
  assert_output --partial "port: 1234"
  assert_output --partial "database: mydatabase"
  assert_output --partial "username: myusername"
  assert_output --partial "password: mypassword"

  assert_executed call-next.sh
  assert_executed_count 1
}

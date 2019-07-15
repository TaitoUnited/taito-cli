#!/usr/bin/env bats

load "${taito_cli_path}/test/util/test-helper"

@test "docker-compose: 'taito db open'" {
  export database_type="pg"
  export database_external_port="1234"
  export database_name="mydatabase"
  export database_username="myusername"
  export database_password="mypassword"
  test db-open#pre

  assert_output --partial "host: 127.0.0.1"
  assert_output --partial "port: 1234"
  assert_output --partial "database: mydatabase"
  assert_output --partial "username: myusername"
  assert_output --partial "password: mypassword"

  assert_executed call-next
  assert_executed_count 1
}

@test "docker-compose: 'taito db open' default username/password for postgres" {
  export database_type="pg"
  export database_external_port="1234"
  export database_name="mydatabase"
  test db-open#pre

  assert_output --partial "host: 127.0.0.1"
  assert_output --partial "port: 1234"
  assert_output --partial "database: mydatabase"
  assert_output --partial "username: mydatabase_app" # default username
  assert_output --partial "password: secret" # default password

  assert_executed call-next
  assert_executed_count 1
}

@test "docker-compose: 'taito db open' default username/password for mysql" {
  export database_type="mysql"
  export database_external_port="1234"
  export database_name="mydatabase"
  test db-open#pre

  assert_output --partial "host: 127.0.0.1"
  assert_output --partial "port: 1234"
  assert_output --partial "database: mydatabase"
  assert_output --partial "username: mydatabaseap" # default username for mysql
  assert_output --partial "password: secret" # default password

  assert_executed call-next
  assert_executed_count 1
}

#!/usr/bin/env bats

# Run directly with bats; Docker and sleeps are stubbed, so no daemon is needed.
setup() {
  source "${BATS_TEST_DIRNAME}/lib/build.bash"
  source "${BATS_TEST_DIRNAME}/lib/push.bash"
  cd "${BATS_TEST_TMPDIR}"
  export docker_log="$PWD/docker.log"
  export docker_state="$PWD/state"
  mkdir server "$docker_state"
  touch server/Dockerfile taitoflag_version "$docker_log"
  export taito_project=project
  export taito_target=server
  export taito_targets='server client'
  export taito_target_env=test
  export taito_container_registry=registry.example/project
  export taito_container_registry_provider=remote
  export taito_project_path="$PWD"
  export taito_docker_new_params=true
  export taito_ci_pull_docker_cache=true
  export taito_mode=ci
  export ci_exec_build=true
  export ci_exec_test=true
  export taito_ci_pull_always=false
  export mock_container=true
  export mock_missing='' mock_tag_failure='' mock_build_failure='' mock_push_failure=''
  export mock_manifest_failure=false
  export mock_save_failure=false
}

function taito::is_current_target_of_type () { [[ $mock_container == true ]]; }
function taito::executing_start () { :; }
function taito::skip_if_not () { :; }
function taito::call_next () { :; }
function sleep () { echo "sleep $*" >> "$docker_log"; }
function docker () {
  echo "docker $*" >> "$docker_log"
  case "$1 $2" in
    'pull '*)
      case "$mock_missing:$2" in
        all:*|cache:*:latest|runtime:*/server:revision-A|builder:*/server-builder:revision-A) return 1 ;;
      esac
      # Mutable latest deliberately contains revision B, not requested A.
      if [[ $2 == *:latest ]]; then
        echo revision-B > "$docker_state/${2//\//_}"
      else
        echo revision-A > "$docker_state/${2//\//_}"
      fi
      ;;
    'image tag')
      [[ -z $mock_tag_failure || $4 != *"$mock_tag_failure"* ]] || return 1
      cat "$docker_state/${3//\//_}" > "$docker_state/${4//\//_}"
      ;;
    'manifest inspect') [[ $mock_manifest_failure == false ]] ;;
    'buildx build')
      if [[ $mock_build_failure == builder && " $* " == *' --target builder '* ]]; then return 23; fi
      if [[ $mock_build_failure == runtime && " $* " != *' --target builder '* ]]; then return 24; fi
      ;;
    'push '*) [[ -z $mock_push_failure || $2 != *"$mock_push_failure"* ]] ;;
    'save --output')
      [[ $mock_save_failure == false ]] || return 25
      touch "$3"
      ;;
  esac
}

# Use a normal failing assertion; Bash errexit does not enforce negated commands.
refute_log() {
  if grep "$@"; then
    echo "Unexpected Docker command matched: $*" >&2
    return 1
  fi
}

build_images() {
  docker::build revision-A '' "${1:-false}" ./server ./server Dockerfile
}
push_images() {
  docker::push revision-A '' false ./server ./server Dockerfile
}
prepare_images() {
  export taito_plugin_path="$BATS_TEST_DIRNAME"
  source "${BATS_TEST_DIRNAME}/artifact-prepare-50" revision-A '' false ./server ./server Dockerfile
}

@test "docker: both builds export inline cache and use separate builder/runtime cache images" {
  run build_images
  [ "$status" -eq 0 ]
  [ "$(grep -c 'docker buildx build --load --build-arg BUILDKIT_INLINE_CACHE=1' "$docker_log")" -eq 2 ]
  grep 'docker buildx build .*--target builder .*--cache-from registry.example/project/server-builder:latest' "$docker_log"
  grep 'docker buildx build .*--cache-from registry.example/project/server-builder:latest --cache-from registry.example/project/server:latest' "$docker_log"
  refute_log -E 'docker buildx (create|use)|--push' "$docker_log"
}




@test "docker: missing optional caches permit a cold build" {
  mock_missing=cache
  run build_images
  [ "$status" -eq 0 ]
  [ "$(grep -c 'docker buildx build' "$docker_log")" -eq 2 ]
  refute_log '^sleep ' "$docker_log"
}







bash_conditional_build() {
  if build_images; then return 0; else return $?; fi
}




@test "docker: legacy arguments still build with inline metadata and custom image path" {
  taito_docker_new_params=false
  run docker::build revision-A ./server ./server Dockerfile registry.example/custom
  [ "$status" -eq 0 ]
  [ "$(grep -c 'docker buildx build --load --build-arg BUILDKIT_INLINE_CACHE=1' "$docker_log")" -eq 2 ]
  grep -- '--tag registry.example/custom/server-builder:revision-A' "$docker_log"
}

@test "docker: separate targets import and export their own image references" {
  mkdir client
  touch client/Dockerfile
  run build_images
  [ "$status" -eq 0 ]
  taito_target=client
  run docker::build revision-A '' false ./client ./client Dockerfile
  [ "$status" -eq 0 ]
  grep 'docker buildx build .*--cache-from registry.example/project/client-builder:latest .*--tag registry.example/project/client-builder:latest' "$docker_log"
  grep 'docker buildx build .*--cache-from registry.example/project/client:latest .*--tag registry.example/project/client:latest' "$docker_log"
}

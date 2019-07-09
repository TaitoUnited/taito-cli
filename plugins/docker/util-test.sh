#!/bin/bash
: "${taito_util_path:?}"
: "${taito_plugin_path:?}"
: "${taito_project:?}"
: "${taito_env:?}"
: "${taito_target_env:?}"
: "${taito_vc_repository:?}"

dir="${taito_target:?Target not given}"
suite_filter="${1}"
test_filter="${2}"

# TODO: should be in taito-cli core only?
if [[ "${taito_mode:-}" == "ci" ]] && [[ "${ci_exec_test:-}" != "true" ]]; then
  # Call next command on command chain
  "${taito_util_path}/call-next.sh" "${@}"
  exit 0
fi

echo "Running tests for ${dir} in ${taito_env} environment"
echo

# Determine command to be run on init phase
init_command="echo 'Not running init (ci_exec_test_init=false)'" && \
if [[ "${ci_exec_test_init:-}" == "true" ]]; then
  init_command="taito ${taito_options:-} init:${taito_env} --clean"
fi && \

# Determine test suite parameters
# Creates docker parameters: -e ENV_VAR='value' -e ENV_VAR2='value2' ...

# Pass all environment variables with the "test_all_" prefix for the test.
d_all_env_vars=$(env | grep "test_all_" | grep -v "npm_package_scripts" | sed "s/^test_all_/-e /" \
  | sed "s/=/='/" | sed "s/$/'/" | tr '\n' ' ' | sed 's/.$//') && \
e_all_env_vars=$(env | grep "test_all_" | grep -v "npm_package_scripts" | sed "s/^test_all_/export /" \
  | tr '\n' ' && ' | sed 's/.$//') && \

# Pass all environment variables with the "test_${dir}_" prefix for the test.
# TODO duplicate code
d_target_env_vars=$(env | grep "test_${dir}_" | grep -v "npm_package_scripts" | sed "s/^test_${dir}_/-e /" \
  | sed "s/=/='/" | sed "s/$/'/" | tr '\n' ' ' | sed 's/.$//') && \
e_target_env_vars=$(env | grep "test_${dir}_" | grep -v "npm_package_scripts" | sed "s/^test_${dir}_/export /" \
  | tr '\n' ' && ' | sed 's/.$//') && \

docker_env_vars="\
  -e taito_running_tests='true' \
  -e taito_target_env='${taito_target_env}' \
  -e taito_env='${taito_target_env}' \
  -e taito_mode='${taito_mode}' \
  ${d_all_env_vars} ${d_target_env_vars}"
export_env_vars=""
if [[ ${e_all_env_vars} ]] || [[ ${e_target_env_vars} ]]; then
  export_env_vars="${e_all_env_vars} ${e_target_env_vars} && "
fi
export_env_vars="\
  export taito_running_tests=true && \
  export taito_target_env=${taito_target_env} && \
  export taito_env=${taito_env} && \
  export taito_mode=${taito_mode} && \
  ${export_env_vars}"

# Determine pod
# shellcheck disable=SC1090
. "${taito_cli_path}/plugins/docker-compose/util/determine-pod.sh" && \

# Determine command to be run on test phase
docker_compose="false"
compose_pre_cmd=""
compose_cmd="docker exec ${docker_env_vars} -it ${pod} ./test.sh SUITE ${test_filter}" && \
if [[ "${taito_env}" != "local" ]]; then
  # Running against a remote service
  container_test="${taito_project}-${dir}-test"
  image_test="${container_test}:latest"
  image_src="${container_test}er:latest"
  if [[ "${taito_mode:-}" != "ci" ]]; then
    # Use development image for testing
    # NOTE: does not exist if project dir is not named after taito_vc_repository
    # NOTE: was ${taito_vc_repository/-/}
    image_src="${taito_vc_repository}_${taito_project}-${dir}"
  fi
  compose_pre_cmd="(docker image tag ${image_src} ${image_test} || \
    (echo ERROR: Container ${image_src} must be built before tests can be run. HINT: taito start && (exit 1))) && "
  if [[ -f ./docker-compose-test.yaml ]] && \
     [[ $(grep "${container_test}" "./docker-compose-test.yaml") ]]; then
    docker_compose="true"
    compose_cmd="docker-compose -f ./docker-compose-test.yaml run --rm ${docker_env_vars} ${container_test} sh -c 'sleep 5 && ./test.sh SUITE ${test_filter}'"
  else
    compose_cmd="docker run ${docker_env_vars} --network=host -v \"\$(pwd)/${dir}:/${dir}\" --entrypoint sh ${image_test} ./test.sh SUITE ${test_filter}"
  fi

  # NOTE: Quick hack for gcp builder -> run tests directly inside taito-cli because
  # sql proxy fails to connect in docker-compose
  if [[ "${taito_plugins}" == *"gcp-ci"* ]] && [[ "${taito_mode:-}" == "ci" ]]; then
    docker_compose="false"
    compose_cmd="${export_env_vars} cd ./${dir} && npm install && ./test.sh SUITE ${test_filter}"
  fi
fi && \

# Create test suite template from init and test phase commands
template="(echo && echo 'TEST ${taito_target}:${taito_env} suite=SUITE' && ${init_command} && ${compose_cmd})"

# Generate commands to be run by traversing all test suites
commands=""
suites=( $(grep "${suite_filter}" "./${dir}/test-suites" 2> /dev/null) ) || :
if [[ ${#suites[@]} == 0 ]]; then
  suites=( $(cat "./${dir}/test-suites" | head -1) )
  echo
  echo -e "${NOTEs}"
  echo "WARNING: No suite found with filter: ${suite_filter}"
  echo "Running the default test suite: ${suites[0]}"
  echo -e "${NOTEe}"
  echo
fi
for suite in "${suites[@]}"
do
  commands="${commands} && ${template//SUITE/$suite}"
done && \

# Execute tests
if [[ ! -z ${commands} ]]; then
  if [[ "${taito_mode:-}" == "ci" ]]; then
    echo "--- EXECUTING ---"
    echo "${compose_pre_cmd}${commands# && }"
    echo "-----------------"
  fi
  "${taito_util_path}/execute-on-host-fg.sh" "${compose_pre_cmd}${commands# && }"
fi && \

# Stop all test containers started by docker-compose
if [[ ${docker_compose} == "true" ]]; then
  "${taito_util_path}/execute-on-host-fg.sh" \
    "docker-compose -f ./docker-compose-test.yaml down || echo OK"
fi && \

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"

#!/bin/bash -e
: "${find_secret_name:?}"

# TODO refactor secret handling!

# Reads secret info to environment variables. The secret in question is
# determined by the given ${find_secret_name}"

found_index=-1
secret_index=0
secret_names=(${taito_secret_names})
for secret_name in "${secret_names[@]}"
do
  . "${taito_util_path}/secret_by_index.bash"
  if [[ "${secret_name}" == "${find_secret_name}" ]]; then
    found_index=${secret_index}
    break
  fi
  secret_index=$((${secret_index}+1))
done

if [[ "${found_index}" != "-1" ]]; then
  secret_index=${found_index}
  . "${taito_util_path}/secret_by_index.bash"
fi

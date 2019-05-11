#!/bin/bash -e
: "${taito_util_path:?}"
: "${taito_plugin_path:?}"
: "${taito_environments:?Environments not set in taito config}"
: "${taito_target_env:?}"
: "${taito_env_merge_source:?}"
: "${taito_env_merge_dest:?}"
: "${taito_env_merges:?}"

# Execute all merges
source_found=""
for merge in ${taito_env_merges[@]}
do
  if [[ "${merge}" == "${taito_env_merge_source}->"* ]] || [[ "${source_found}" ]]; then
    source_found=true
    branch="${merge##*->}"
    "${taito_plugin_path}/util/ci.sh" "$branch"
  fi
  if [[ "${merge}" == *"->${taito_env_merge_dest}" ]]; then
    break
  fi
done
echo

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"

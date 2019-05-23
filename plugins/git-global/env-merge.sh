#!/bin/bash -e
: "${taito_util_path:?}"
: "${taito_environments:?Environments not set in taito config}"
: "${taito_target_env:?}"
: "${taito_env_merge_source:?}"
: "${taito_env_merge_dest:?}"
: "${taito_env_merges:?}"

if ! git rev-parse --is-inside-work-tree &> /dev/null; then
  # Not a git repository -> call next command on command chain and exit
  "${taito_util_path}/call-next.sh" "${@}"
  exit
fi

# Parse arguments
git_push_options=""
while [[ $# -gt 0 ]]
do
  if [[ ${1} == "--force" ]]; then
    git_push_options="--force-with-lease"
  fi
  shift
done

# Execute all merges
source_found=""
for merge in ${taito_env_merges[@]}
do
  if [[ "${merge}" == "${taito_env_merge_source}->"* ]] || [[ "${source_found}" ]]; then
    source_found=true
    s="${merge%->*}"
    d="${merge##*->}"
    echo -e "${H2s}${s}->${d} ${git_push_options}${H2e}"

    # Check if production env has been configured
    if [[ ${d} == "master" ]] && ( \
         [[ $(grep "\\* \\[ \\] Production done" CONFIGURATION.md 2> /dev/null) != "" ]] || \
         [[ $(grep "\\* \\[ \\] All done" CONFIGURATION.md 2> /dev/null) != "" ]] \
      ); then
      echo
      echo "----------------------------------------------------------------------"
      echo "WARNING! The production environment has not yet been fully configured."
      echo "See the '[ ] Production done' and '[ ] All done' checkboxes in"
      echo "CONFIGURATION.md."
      echo "----------------------------------------------------------------------"
    fi

    # TODO execution should end if one merge fails

    "${taito_util_path}/execute-on-host-fg.sh" "\
    echo && \
    (read -t 1 -n 10000 discard || :) && \
    echo \"Merging ${s} -> ${d} ${git_push_options}\" && \
    echo \"Do you want to continue (Y/n)?\" && \
    read -r confirm && \
    if ! [[ \${confirm:-y} =~ ^[Yy]*$ ]]; then \
      exit 130; \
    fi && \
    echo Merging... && \
    git fetch origin ${s}:${d} && \
    git push --no-verify ${git_push_options} origin ${d} && \
    if [[ \"${taito_ci_provider:-}\" == \"local\" ]]; then
      echo && \
      echo ---------------------------------------------------------------------- && \
      echo TIP: Run \\'taito ci run:${d/master/prod}\\' to execute CI/CD locally. && \
      echo ---------------------------------------------------------------------- && \
      echo
    fi || \
    (echo && echo 'ERROR: MERGING FAILED!!!!' && echo 'NOTE: You can do force push with --force if you really want to overwrite all changes on branch ${d} --> TODO --force does not work yet?') \
    "
  fi
  if [[ "${merge}" == *"->${taito_env_merge_dest}" ]]; then
    break
  fi
done
echo

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"
